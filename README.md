Some code from my vector quantization paper I published as a PhD student: 

> Wyatt T. Clark and Predrag Radivojac. [Vector quantization kernels for the classification of protein sequences and
structures](https://psb.stanford.edu/psb-online/proceedings/psb14/clark.pdf). *Pacific Symposium on Biocomputing*, 19:316–327, 2014.

This paper used VQ to predict SCOP categories of protein strucutres.  Briefly, n-length windows of protein phi and psi backbone angles (amonst other properties) were used to perform unsupervised learning. Proteins were then encoded using a sliding windown, representing each window as the cluster that feature belonged to. Counts of the number of times each cluster was identified were then used as a feature representation to perform supervised learning and predict SCOP class.
