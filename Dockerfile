FROM debian:bookworm-slim

USER root
ENV DEBIAN_FRONTEND=noninteractive

# Install only the absolute essentials to save RAM
RUN apt-get update && apt-get install -y \
    lxde-core \
    tigervnc-standalone-server \
    novnc \
    python3-websockify \
    firefox-esr \
    procps \
    dbus-x11 \
    && apt-get clean

# Setup VNC password
RUN mkdir -p /root/.vnc && echo "password" | vncpasswd -f > /root/.vnc/passwd && chmod 600 /root/.vnc/passwd

# Fix noVNC index
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Koyeb uses port 8000 or 8080 by default, but we can stick to 8080
EXPOSE 8080
CMD ["/startup.sh"]
