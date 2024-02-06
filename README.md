<div align="center">
  <h1>Embed my Python</h1>

  <blockquote>Simplify the process of setting up a Python environment with specific versions and dependencies across various operating systems.</blockquote>

  <img src="resources/logo.jpg" title="Embed my Python logo" />
</div>

---

## Table of Contents

<!-- toc -->

- [Features](#features)
- [Setup](#setup)
- [Usage](#usage)
  - [Windows](#windows)
- [CLI Parameters](#cli-parameters)
- [Feedback](#feedback)

<!-- tocstop -->

## Features

- **Automated Setup**: Effortlessly set up an embedded Python environment including all your requirements in one step
- **Customizable Python Version**: Choose the Python version that best fits your project's needs.
- **Dependency Management**: Easily manage and install dependencies with a requirements file.
- **Cross-Platform Compatibility**: Support for Windows (done), macOS (planned), and Linux (planned).

## Setup

1. Clone or download the repository

## Usage

### Windows

1. Open PowerShell.
2. Navigate to the `embed-my-python` folder.
3. Execute the script using optional [CLI parameters](#cli-parameters):

   ```powershell
   .\embed-my-python-win.ps1 -v 3.10.9 -r D:\dev\myproject\requirements.txt -d D:\dev\myproject\python-embedded
   ```

## CLI Parameters

| Option | Description                                                                 | Default Value        |
| ------ | --------------------------------------------------------------------------- | -------------------- |
| `-v`   | Specify the Python version to use for the embedded environment.             | `3.10.9`             |
| `-r`   | Path to the `requirements.txt` file with the necessary Python packages.     | `.\requirements.txt` |
| `-d`   | Destination directory where the embedded Python environment will be set up. | `.\python-embedded`  |

## Feedback

Your feedback is invaluable to us! If you have any suggestions, issues, or ideas for improvements, please feel free to open an issue or submit a pull request. We're committed to making EmbedMyPython better with your help!
