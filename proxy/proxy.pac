function FindProxyForURL(url, host) {
    host = host.toLowerCase();

    if (host === "localhost" || dnsDomainIs(host, ".local") || isPlainHostName(host)) {
        return "DIRECT";
    }

    return "PROXY 127.0.0.1:3128; DIRECT";
}
