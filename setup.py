import os, sys
from setuptools import setup
from setuptools.command.develop import develop
from setuptools.command.install import install


class CustomDevelopCommand(develop):
    """Customized setuptools install command - prints a friendly greeting."""
    def run(self):
        print("************ Hello, developer, how are you? :)")
        develop.run(self)


setup(
    name="pyromania",
    version="0.1.0",
    description="Pyromania",
    long_description="",
    author="Tim Allen",
    author_email="flipper@peregrinesalon.com",
    url="https://github.com/flipperpa/pyromania",
    zip_safe=False,
    classifiers=[
        "Development Status :: 4 - Beta",
        "Environment :: Web Environment",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: BSD License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
    ],
    cmdclass={
        'develop': CustomDevelopCommand,
        # 'install': CustomDevelopCommand,
    },
)
"""
"""