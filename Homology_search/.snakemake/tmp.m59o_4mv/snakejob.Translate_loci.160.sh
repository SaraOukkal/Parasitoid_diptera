#!/bin/sh
# properties = {"type": "single", "rule": "Translate_loci", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_014805625.1/Fasta_viral_loci1.fna"], "output": ["/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_014805625.1/Fasta_viral_loci.faa"], "wildcards": {"Genome_ID": "GCF_014805625.1"}, "params": {"threads": "1", "time": "00:15:00", "name": "Translate_loci_GCF_014805625.1", "out": "/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Translate_loci_GCF_014805625.1.out", "err": "/beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Translate_loci_GCF_014805625.1.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 160, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/Homology_search && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_014805625.1/Fasta_viral_loci.faa --snakefile /beegfs/data/soukkal/StageM2/Scripts/Homology_search/Snakemake_viral_homology_Control \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.m59o_4mv /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/GCF_014805625.1/Fasta_viral_loci1.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules Translate_loci --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.m59o_4mv/160.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.m59o_4mv/160.jobfailed; exit 1)

