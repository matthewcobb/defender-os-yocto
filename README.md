# Defender Automotive OS

An in-car entertainment system built with Yocto and Qt for modern vehicles.

## Features

- Modern Qt-based UI with Wayland/labwc compositor
- Dashboard display with car metrics and controls
- Apple CarPlay integration
- Application launcher and settings manager
- Optimized for automotive use cases

## System Architecture

The system is built using the following components:

- **Yocto Project (Kirkstone)**: Base build system
- **Qt 6**: UI framework
- **Wayland/labwc**: Display server and compositor
- **Defender Dashboard**: Car metrics display
- **Defender CarPlay**: Apple CarPlay integration
- **Defender Launcher**: Application launcher
- **Defender Settings**: System settings

## Build Instructions

### Prerequisites

- Linux host system (Ubuntu 20.04 or newer recommended)
- At least 100GB free disk space
- At least 8GB of RAM
- Required packages:
  ```
  sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
  build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
  xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
  pylint3 xterm python3-subunit mesa-common-dev zstd liblz4-tool
  ```

### Building the Image

1. **Set up build environment**:
   ```bash
   source poky-source/oe-init-build-env build
   ```

2. **Verify configuration**:
   The `conf/local.conf` and `conf/bblayers.conf` should already be set up correctly.
   Verify that the contents match the expected configuration.

3. **Build the image**:
   ```bash
   bitbake defender-automotive-image
   ```
   This will take several hours depending on your hardware.

4. **Run the emulator** (for testing):
   ```bash
   runqemu defender-automotive
   ```

## Development

To modify the system or create new applications:

1. **Modifying existing apps**:
   Applications are located in `meta-defender/recipes-automotive/`

2. **Creating new apps**:
   - Create a new recipe directory in `meta-defender/recipes-automotive/`
   - Add a package recipe file, source files, and build configuration
   - Add the app to `IMAGE_INSTALL` in `meta-defender/recipes-core/images/defender-automotive-image.bb`

3. **Building only specific components**:
   ```bash
   bitbake defender-dashboard
   ```

## Deployment

To deploy to real hardware:

1. **Locate the image**:
   After building, the image will be in `build/tmp/deploy/images/defender-automotive/`

2. **Flash the image**:
   Use the appropriate method for your hardware, typically:
   ```bash
   sudo dd if=defender-automotive-image.wic of=/dev/sdX bs=4M status=progress
   ```
   Replace `/dev/sdX` with your target device.

## License

This project is licensed under the MIT License.