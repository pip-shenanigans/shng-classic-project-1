import unittest


# fmt: off
packages_versions = {
    "shng-classic-library-1": "0.0.1",
    "shng-classic-library-2": "0.2.0",
    "shng-classic-library-3": "0.0.1",
}
# fmt: on


class PackgesVersions(unittest.TestCase):

    def _check_package_version(self, package_name, package_version):
        pkg = __import__(package_name)
        assert pkg.NAME == package_name
        assert pkg.VERSION == package_version

    def test_installed_packages_versions(self):
        assert len(packages_versions) > 0
        for package_name, package_version in packages_versions:
            self._check_package_version(package_name, package_version)

