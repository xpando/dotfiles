package main

import (
	"encoding/json"
	"flag"
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

func GetLatestReleaseDownloadURL(owner, repo, assetPattern string) (string, string, error) {
	// Construct the URL for the latest release
	url := fmt.Sprintf("%s/%s/%s/releases/latest", githubAPIBase, owner, repo)

	// Fetch the latest release
	resp, err := http.Get(url)
	if err != nil {
		return "", "", fmt.Errorf("error fetching latest release: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", "", fmt.Errorf("failed to fetch latest release, status code: %d", resp.StatusCode)
	}

	// Decode the JSON response
	var release Release
	if err := json.NewDecoder(resp.Body).Decode(&release); err != nil {
		return "", "", fmt.Errorf("error decoding latest release response: %w", err)
	}

	// Compile the regex pattern
	pattern, err := regexp.Compile(assetPattern)
	if err != nil {
		return "", "", fmt.Errorf("invalid regex pattern: %w", err)
	}

	// Find the asset that matches the pattern
	for _, asset := range release.Assets {
		if pattern.MatchString(asset.Name) {
			return asset.Name, asset.DownloadURL, nil
		}
	}

	return "", "", fmt.Errorf("no asset found matching the pattern")
}

func DownloadFileWithProgress(url, filepath string) error {
	fmt.Printf("Downloading %s\n", filepath)

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
	file, err := os.Create(filepath)
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

func main() {
	osName := runtime.GOOS
	fmt.Printf("Installing fonts for %s\n", osName)

	// Define command-line flags
	owner := flag.String("owner", "", "GitHub repository owner")
	repo := flag.String("repo", "", "GitHub repository name")
	assetPattern := flag.String("asset", "", "Regex pattern for the asset name")
	outputDir := flag.String("outputDir", "/tmp", "The directory to download the asset to")

	// Parse command-line flags
	flag.Parse()

	// Check if the required flags are provided
	if *owner == "" || *repo == "" || *assetPattern == "" {
		fmt.Println("Usage: go run gh-download.go --owner <owner> --repo <repo> --outputDir <outputDir>")
		flag.PrintDefaults()
		os.Exit(1)
	}

	// Get the latest release download URL
	assetName, url, err := GetLatestReleaseDownloadURL(*owner, *repo, *assetPattern)
	if err != nil {
		log.Fatalf("Error: %v", err)
	}

	if err := DownloadFileWithProgress(url, filepath.Join(*outputDir, assetName)); err != nil {
		fmt.Println("Download error:", err)
	}
}

