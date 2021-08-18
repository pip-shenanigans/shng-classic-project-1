import unittest


# fmt: off
packages_versions = {
    "shng_classic_library_1": "this-version",
    "shng_classic_library_2": "0.2.0",
    "shng_classic_library_3": "0.0.1",
    "shng_classic_library_4": "0.3.0",
    "shng_classic_library_5": "0.2.0",
}
# fmt: on


class PackgesVersions(unittest.TestCase):

    def _check_package_version(self, package_name, package_version):
        pkg = __import__(package_name)
        assert pkg.NAME == package_name
        assert pkg.VERSION == package_version

    def test_installed_packages_versions(self):
        assert len(packages_versions) > 0
        for package_name, package_version in packages_versions.items():
            self._check_package_version(package_name, package_version)

