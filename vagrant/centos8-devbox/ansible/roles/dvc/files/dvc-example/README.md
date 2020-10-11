# About

DVC tracks ML models and data sets, making ML experiments and data transformations in general reproducible.
It is designed to handle large files, data sets, machine learning models, metrics and code.
Files can be shared between experiments, branches, users and CI builds. In addition to managing data files,
DVC can track data pipelines in Git: input files, output files and the command to produce the result. 

DVC runs on top of Git. DVC uses metadata files as placeholders to track data files and directories in Git.
The metadata files and data files provisioned by DVC point to data contents in a cache that can be synchronized
with remote storage. DVC can use Amazon S3, Microsoft Azure Blob Storage, Google Drive, Google Cloud Storage, Aliyun OSS, 
SSH/SFTP, HDFS, HTTP, network-attached storage, or disc to store data.

# References

- [https://dvc.org](DVC)
- [Why Git and Git-LFS is not enough to solve the Machine Learning Reproducibility crisis](https://towardsdatascience.com/why-git-and-git-lfs-is-not-enough-to-solve-the-machine-learning-reproducibility-crisis-f733b49e96e8)


