PROXY_GIT = ''
ENABLE = True


def proxy_url(url, source_type='git'):
    if not ENABLE:
        return url
    if source_type == 'git':
        if 'ghproxy.com' not in url and ('github.com' in url or 'raw.githubusercontent.com' in url):
            new_url = f'https://ghproxy.com/{url}'
            print(f'proxy url {url} to {new_url}')
            return new_url
    return url
