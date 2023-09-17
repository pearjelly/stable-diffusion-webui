from modules import launch_utils

args = launch_utils.args
python = launch_utils.python
git = launch_utils.git
index_url = launch_utils.index_url
dir_repos = launch_utils.dir_repos

commit_hash = launch_utils.commit_hash
git_tag = launch_utils.git_tag

run = launch_utils.run
is_installed = launch_utils.is_installed
repo_dir = launch_utils.repo_dir

run_pip = launch_utils.run_pip
check_run_python = launch_utils.check_run_python
git_clone = launch_utils.git_clone
git_pull_recursive = launch_utils.git_pull_recursive
list_extensions = launch_utils.list_extensions
run_extension_installer = launch_utils.run_extension_installer
prepare_environment = launch_utils.prepare_environment
configure_for_tests = launch_utils.configure_for_tests
start = launch_utils.start

# begin 覆盖load_file_from_url,使用ghproxy加速github访问
from basicsr.utils import download_util
import os


def load_file_from_url_user_proxy(url, model_dir=None, progress=True, file_name=None):
    from proxy import util
    url = util.proxy_url(url)
    if model_dir is None:  # use the pytorch hub_dir
        hub_dir = download_util.get_dir()
        model_dir = os.path.join(hub_dir, 'checkpoints')

    os.makedirs(model_dir, exist_ok=True)
    parts = download_util.urlparse(url)
    filename = os.path.basename(parts.path)
    if file_name is not None:
        filename = file_name
    cached_file = os.path.abspath(os.path.join(model_dir, filename))
    if not os.path.exists(cached_file):
        print(f'Downloading: "{url}" to {cached_file}\n')
        download_util.download_url_to_file(url, cached_file, hash_prefix=None, progress=progress)
    return cached_file


download_util.load_file_from_url = load_file_from_url_user_proxy

from git.repo import base
from git.types import (
    PathLike,
)
from typing import (
    Callable,
    List,
    Mapping,
    Optional,
)


class ProxyRepo(base.Repo):
    @classmethod
    def clone_from_with_proxy(
            cls,
            url: PathLike,
            to_path: PathLike,
            progress: Optional[Callable] = None,
            env: Optional[Mapping[str, str]] = None,
            multi_options: Optional[List[str]] = None,
            allow_unsafe_protocols: bool = False,
            allow_unsafe_options: bool = False,
            **kwargs,
    ):
        from proxy import util
        url = util.proxy_url(url)
        base.Repo.clone_from(url, to_path, progress, env, multi_options, allow_unsafe_protocols, allow_unsafe_options,
                             **kwargs)


base.Repo = ProxyRepo


# end


def main():
    if args.dump_sysinfo:
        filename = launch_utils.dump_sysinfo()

        print(f"Sysinfo saved as {filename}. Exiting...")

        exit(0)

    launch_utils.startup_timer.record("initial startup")

    with launch_utils.startup_timer.subcategory("prepare environment"):
        if not args.skip_prepare_environment:
            prepare_environment()

    if args.test_server:
        configure_for_tests()

    start()


if __name__ == "__main__":
    main()
