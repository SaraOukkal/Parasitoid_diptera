#!/bin/sh
# properties = {"type": "single", "rule": "Extract_loci", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_013731165.1/run_mmseqs2/result_mmseqs2_strand_summary_V.bed", "/beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCF_013731165.1.fna"], "output": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_013731165.1/run_mmseqs2/Result.bed", "/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_013731165.1/Fasta_viral_loci1.fna"], "wildcards": {"Genome_ID": "GCF_013731165.1"}, "params": {"threads": "1", "time": "00:15:00", "name": "Extract_loci_GCF_013731165.1", "out": "/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Extract_loci_GCF_013731165.1.out", "err": "/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Extract_loci_GCF_013731165.1.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 119, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/Homology_search && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_013731165.1/Fasta_viral_loci1.fna --snakefile /beegfs/data/soukkal/StageM2/Scripts/Homology_search/Snakemake_viral_homology_Control \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.p6s8k7tj /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_013731165.1/run_mmseqs2/result_mmseqs2_strand_summary_V.bed /beegfs/data/soukkal/StageM2/Control_genomes/genomes/GCF_013731165.1.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules Extract_loci --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.p6s8k7tj/119.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.p6s8k7tj/119.jobfailed; exit 1)

