RUN wget https://github.com/obsidianmd/obsidian-releases/releases/download/v0.12.19/obsidian-0.12.19.tar.gz && \
    tar -xf obsidian-0.12.19.tar.gz && rm obsidian-0.12.19.tar.gz && \
    mv obsidian-0.12.19 /opt
