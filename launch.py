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
run_extension_installer = launch_utils.run_extension_installer
prepare_environment = launch_utils.prepare_environment
configure_for_tests = launch_utils.configure_for_tests
start = launch_utils.start

# begin 覆盖load_file_from_url,使用ghproxy加速github访问
from basicsr.utils import download_util


def load_file_from_url_user_proxy(url, model_dir=None, progress=True, file_name=None):
    from proxy import util
    url = util.proxy_url(url)
    download_util.load_file_from_url(url, model_dir, progress, file_name)


download_util.load_file_from_url = load_file_from_url_user_proxy

from git.repo import base


def clone_from_with_proxy(
        cls,
        url,
        to_path,
        progress,
        env,
        multi_options,
        allow_unsafe_protocols,
        allow_unsafe_options,
        **kwargs,
):
    from proxy import util
    url = util.proxy_url(url)
    base.Repo.clone_from(cls, url, to_path, progress, env, multi_options, allow_unsafe_protocols, allow_unsafe_options,
                         **kwargs)


base.Repo.clone_from = clone_from_with_proxy


# end


def main():
    if not args.skip_prepare_environment:
        prepare_environment()

    if args.test_server:
        configure_for_tests()

    start()


if __name__ == "__main__":
    main()
