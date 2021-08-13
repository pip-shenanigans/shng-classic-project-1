import setuptools
import site
import sys

# https://github.com/pypa/pip/issues/7953
site.ENABLE_USER_SITE = "--user" in sys.argv[1:]

PACKAGE = "shng_classic_project_1"
pkg = __import__(PACKAGE)


# fmt: off
install_requires = [
    "shng-classic-library-1",
    "shng-classic-library-3",
    "requests",
]
# fmt: on


setuptools.setup(
    name=pkg.NAME,
    version=pkg.VERSION,
    packages=setuptools.find_packages(),
    zip_safe=False,
    python_requires=">3.6.1,<3.7",
    ### setup_requires=["pytest-runner"],
    ### tests_require=["pytest", "pytest-flakes", "pytest-black", "pytest-cov", "pytest-cache"],
    install_requires=install_requires,
)
