#!/bin/sh
# properties = {"type": "single", "rule": "Extract_loci", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/lixophaga_wood06/run_mmseqs2/result_mmseqs2_strand_summary_V.bed", "/beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/lixophaga_wood06.fna"], "output": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/lixophaga_wood06/Test.bed", "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/lixophaga_wood06/Fasta_viral_loci1.fna", "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/lixophaga_wood06/Fasta_viral_loci.fna"], "wildcards": {"Genome_ID": "lixophaga_wood06"}, "params": {"threads": "1", "time": "00:15:00", "name": "Extract_loci_lixophaga_wood06", "out": "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Extract_loci_lixophaga_wood06.out", "err": "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Extract_loci_lixophaga_wood06.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 103, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/Homology_search && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/lixophaga_wood06/Fasta_viral_loci.fna --snakefile /beegfs/data/soukkal/StageM2/Scripts/Homology_search/Snakemake_viral_homology_Tachinids \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.kf36ttje /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/lixophaga_wood06/run_mmseqs2/result_mmseqs2_strand_summary_V.bed /beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/lixophaga_wood06.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules Extract_loci --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.kf36ttje/103.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.kf36ttje/103.jobfailed; exit 1)

