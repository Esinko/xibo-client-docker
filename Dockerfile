FROM scottyhardy/docker-wine

# ----------------------
# Dependencies and setup
# ----------------------

# Set workdir
WORKDIR /xibo-wine/

# Install some general dependencies. Requirements will be verified later.
# At least wget and cabextract are required.
RUN apt-get update >> /dev/null && apt-get install -y gnupg2 software-properties-common wget winbind cabextract >> /dev/null

# Experimental dependencies for video playback
# TODO: Could both versions x86 and i386 be installed with a single line? Or at least in a cleaner way.
#       Do we need i386 anyway? WINE should right?
RUN apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio >> /dev/null
RUN apt-get install -y libgstreamer1.0-dev:i386 libgstreamer-plugins-base1.0-dev:i386 libgstreamer-plugins-bad1.0-dev:i386 gstreamer1.0-plugins-base:i386 gstreamer1.0-plugins-good:i386 gstreamer1.0-plugins-bad:i386 gstreamer1.0-plugins-ugly:i386 gstreamer1.0-libav:i386 gstreamer1.0-tools:i386 gstreamer1.0-x:i386 gstreamer1.0-alsa:i386 gstreamer1.0-gl:i386 gstreamer1.0-gtk3:i386 gstreamer1.0-qt5:i386 gstreamer1.0-pulseaudio:i386 >> /dev/null

# Install dotnet472, dxvk (dirextX to Vulkan) and disable WINE's crash dialog
RUN winetricks -q dotnet472 corefonts dxvk nocrashdialog &> /dev/null

# TODO: Can we handle WINE configuration here?

# ----------------------
# Install the software
# ----------------------

# Install Xibo V3 (3R301)
RUN wget -nc "https://github.com/xibosignage/xibo-dotnetclient/releases/download/3R301/xibo-client-v3-R301.1-win32-x86.msi" -q --show-progress

# Disable caching for further instructions during development
# ARG CACHE_BREAK=Cache_will_not_be_used_after_this

# Define and copy entrypoint
COPY ./entrypoint.sh ./entrypoint.sh
ENTRYPOINT [ "/xibo-wine/entrypoint.sh" ]
