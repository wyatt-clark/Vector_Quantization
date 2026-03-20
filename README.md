Some code from my vector quantization paper I published as a PhD student: 

> Wyatt T. Clark and Predrag Radivojac. [Vector quantization kernels for the classification of protein sequences and
structures](https://psb.stanford.edu/psb-online/proceedings/psb14/clark.pdf). *Pacific Symposium on Biocomputing*, 19:316–327, 2014.

This paper used protein strucutre backbone phi and psi angles (amonst other features), then clustered n-length windowed values. These protein features were then encoded using a sliding windown, and representing each window as the cluster it belonged to. If I remember corretly, I then used counts of the number of times each cluster was identified as a feature encoding to perform supervised learning and predict SCOP class.
