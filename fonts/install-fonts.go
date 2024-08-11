package main

import (
	"archive/zip"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"runtime"
	"time"
)

type Config struct {
	CacheDir string            `json:"cacheDir"`
	FontDir  map[string]string `json:"fontDir"`
	Repos    []Repo            `json:"repos"`
}

type Repo struct {
	Owner string `json:"owner"`
	Name  string `json:"name"`
	Fonts []Font `json:"fonts"`
}

type Font struct {
	AssetName  string `json:"assetName"`
	AssetFiles string `json:"assetFiles"`
}

// GitHub API URL for the latest release
const githubAPIBase = "https://api.github.com/repos"

// Release represents the structure of a GitHub release response
type Release struct {
	Assets []Asset `json:"assets"`
}

// Asset represents the structure of a GitHub release asset
type Asset struct {
	Name        string `json:"name"`
	DownloadURL string `json:"browser_download_url"`
}

func GetLatestReleaseAssets(repo Repo, font Font) <-chan Asset {
	out := make(chan Asset)

	go func() {
		defer close(out)

		// Construct the URL for the latest release
		url := fmt.Sprintf("%s/%s/%s/releases/latest", githubAPIBase, repo.Owner, repo.Name)

		// Fetch the latest release
		resp, err := http.Get(url)
		if err != nil {
			fmt.Printf("Error fetching latest release: %w", err)
			return
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			fmt.Printf("Failed to fetch latest release, status code: %d", resp.StatusCode)
			return
		}

		// Decode the JSON response
		var release Release
		if err := json.NewDecoder(resp.Body).Decode(&release); err != nil {
			fmt.Printf("error decoding latest release response: %w", err)
			return
		}

		// Compile the regex pattern
		assetNamePattern, err := regexp.Compile(font.AssetName)
		if err != nil {
			fmt.Printf("invalid regex pattern: %w", err)
			return
		}

		for _, asset := range release.Assets {
			if assetNamePattern.MatchString(asset.Name) {
				out <- asset
			}
		}
	}()

	return out
}

func DownloadFileWithProgress(url string, filePath string) error {
	if _, err := os.Stat(filePath); errors.Is(err, os.ErrNotExist) {
		// file does not exist
		fmt.Printf("Downloading %s to %s\n", url, filePath)

		// Make HTTP GET request
		resp, err := http.Get(url)
		if err != nil {
			return fmt.Errorf("failed to start download: %w", err)
		}
		defer resp.Body.Close()

		// Check if response status is OK
		if resp.StatusCode != http.StatusOK {
			return fmt.Errorf("failed to download file: status code %d", resp.StatusCode)
		}

		// Create the file to save the downloaded content
		file, err := os.Create(filePath)
		if err != nil {
			return fmt.Errorf("failed to create file: %w", err)
		}
		defer file.Close()

		// Get the total size of the file
		totalSize := resp.ContentLength
		if totalSize <= 0 {
			return fmt.Errorf("invalid content length")
		}

		// Buffer to read the data
		buffer := make([]byte, 4096)
		var downloadedSize int64

		startTime := time.Now()

		// Read and write the data while showing progress
		for {
			n, err := resp.Body.Read(buffer)
			if n > 0 {
				if _, err := file.Write(buffer[:n]); err != nil {
					return fmt.Errorf("failed to write data to file: %w", err)
				}

				downloadedSize += int64(n)
				percent := float64(downloadedSize) / float64(totalSize) * 100
				elapsed := time.Since(startTime).Seconds()
				speed := float64(downloadedSize) / elapsed / 1024 // speed in KB/s

				fmt.Printf("\rProgress: %.2f%%, Speed: %.2f KB/s", percent, speed)
			}

			if err == io.EOF {
				break
			}

			if err != nil {
				return fmt.Errorf("failed to read data: %w", err)
			}
		}

		fmt.Println("\nDownload complete!")
		return nil
	}
	fmt.Printf("Using previously downloaded file: %s\n", filePath)
	return nil
}

func Unzip(src string, dest string, filePattern string) error {
	// Compile the regex pattern
	pattern, err := regexp.Compile(filePattern)
	if err != nil {
		return fmt.Errorf("invalid regex pattern: %w", err)
	}

	// Open the ZIP file
	r, err := zip.OpenReader(src)
	if err != nil {
		return fmt.Errorf("failed to open ZIP file: %w", err)
	}
	defer r.Close()

	// Iterate through the files in the archive
	fmt.Printf("Unzipping from %s to %s\n", src, dest)
	for _, f := range r.File {
		if !pattern.MatchString(f.Name) {
			fmt.Printf("Skipping %s because it did not match pattern: %s\n", f.Name, filePattern)
			continue
		}

		// Create the full path for the extracted file
		fpath := filepath.Join(dest, f.Name)

		// Check if the file is a directory
		if f.FileInfo().IsDir() {
			// Create the directory
			if err := os.MkdirAll(fpath, f.Mode()); err != nil {
				return fmt.Errorf("failed to create directory %s: %w", fpath, err)
			}
			continue
		}

		// Create the directory for the file
		if err := os.MkdirAll(filepath.Dir(fpath), os.ModePerm); err != nil {
			return fmt.Errorf("failed to create directory %s: %w", filepath.Dir(fpath), err)
		}

		// Open the file inside the ZIP
		srcFile, err := f.Open()
		if err != nil {
			return fmt.Errorf("failed to open file %s in ZIP: %w", f.Name, err)
		}
		defer srcFile.Close()

		// Create the destination file
		destFile, err := os.Create(fpath)
		if err != nil {
			return fmt.Errorf("failed to create file %s: %w", fpath, err)
		}
		defer destFile.Close()

		// Copy the content from the source file to the destination file
		fmt.Printf("Extracting %s to %s\n", f.Name, fpath)
		if _, err := io.Copy(destFile, srcFile); err != nil {
			return fmt.Errorf("failed to copy file %s: %w", f.Name, err)
		}
	}
	return nil
}

func main() {
	configFile, err := os.Open("fonts.json")
	if err != nil {
		log.Fatalf("Could not read config file fonts.json: %s", err)
	}
	defer configFile.Close()

	var config Config
	decoder := json.NewDecoder(configFile)
	err = decoder.Decode(&config)
	if err != nil {
		log.Fatalf("Could not parse fonts.json. %s", err)
	}

	fontDir, exists := config.FontDir[runtime.GOOS]
	if !exists {
		log.Fatalf("Missing fontDir config for OS: %s", runtime.GOOS)
	}

	for _, repo := range config.Repos {
		for _, font := range repo.Fonts {
			for asset := range GetLatestReleaseAssets(repo, font) {
				cachePath := filepath.Join(config.CacheDir, asset.Name)
				if err := DownloadFileWithProgress(asset.DownloadURL, cachePath); err != nil {
					fmt.Println("Download error: ", err)
					continue
				}

				if err := Unzip(cachePath, fontDir, font.AssetFiles); err != nil {
					log.Fatalf("Failed to unzip %s to %s", cachePath, fontDir)
				}
			}
		}
	}
}
