#!/usr/bin/env bash

# Function to print a progress bar
print_progress_bar() {
    local duration=$1
    local symbol="."

    for ((i = 0; i < duration; i++)); do
        echo -n "$symbol"
        sleep 1
    done
    echo
}

# Function to print in color
print_color() {
    local color_code="$1"
    shift
    echo -e "\e[38;5;${color_code}m$@\e[0m"
}

# Check if 'conda' command is available
if ! command -v conda &> /dev/null; then
  print_color 9 "Anaconda is not installed. Please install Anaconda and try again."
  exit 1
else
  print_color 82 "Anaconda is installed."
  conda_version=$(conda --version)
  print_color 208 "Anaconda version: $conda_version"
fi

# Get the current Anaconda environment name (if any)
conda_env="$CONDA_DEFAULT_ENV"
print_color 198 "Your current conda env = $conda_env"

if [ "$conda_env" == "base" ]; then
  # In the base environment
  anaconda_path="$HOME/anaconda3"  # Replace with your Anaconda installation path
else
  # In a custom environment
  anaconda_path="$HOME/anaconda3/envs/$conda_env"  # Replace with your Anaconda installation path
fi

# Define the path to 'samtools' within the Anaconda environment
samtools_path="$anaconda_path/bin/samtools"

# Check if 'samtools' is installed
if [ ! -e "$samtools_path" ]; then
  print_color 161 "samtools is not installed in $conda_env environment."
  exit 1
else
  print_color 11 "samtools is installed in $conda_env environment."
fi

# Path to the 'lib' folder in the Anaconda environment
lib_folder="$anaconda_path/lib"

# Check if 'libcrypto.so.1.0.0' symbolic link exists
if [ -h "$lib_folder/libcrypto.so.1.0.0" ]; then
  print_color 14 "The symbolic link 'libcrypto.so.1.0.0' already exists in the 'lib' folder."
else
  print_color 14 "Creating a symbolic link to libcrypto.so.1.1 as libcrypto.so.1.0.0..."
  cd "$lib_folder"
  ln -s libcrypto.so.1.1 libcrypto.so.1.0.0
  print_progress_bar 3  # Progress bar with a duration of 3 seconds
  print_color 118 "Symbolic link created successfully."
fi
