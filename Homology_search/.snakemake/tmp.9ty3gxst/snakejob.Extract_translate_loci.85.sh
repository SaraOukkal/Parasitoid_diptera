#!/bin/sh
# properties = {"type": "single", "rule": "Extract_translate_loci", "local": false, "input": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/houghia_brevipilosa/run_mmseqs2/result_mmseqs2_strand_summary_V.bed", "/beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/houghia_brevipilosa.fna"], "output": ["/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/houghia_brevipilosa/Fasta_viral_loci.fna", "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/houghia_brevipilosa/Fasta_viral_loci.faa"], "wildcards": {"Genome_ID": "houghia_brevipilosa"}, "params": {"threads": "2", "time": "00:15:00", "name": "Extract_translate_houghia_brevipilosa", "out": "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Extract_translate_houghia_brevipilosa.out", "err": "/beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Extract_translate_houghia_brevipilosa.error"}, "log": [], "threads": 1, "resources": {}, "jobid": 85, "cluster": {}}
 cd /beegfs/data/soukkal/StageM2/Scripts/Homology_search && \
/beegfs/data/bguinet/Bguinet_conda/bin/python \
-m snakemake /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/houghia_brevipilosa/Fasta_viral_loci.fna --snakefile /beegfs/data/soukkal/StageM2/Scripts/Homology_search/Snakemake_viral_homology_Tachinids \
--force -j --keep-target-files --keep-remote --max-inventory-time 0 \
--wait-for-files /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.9ty3gxst /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/houghia_brevipilosa/run_mmseqs2/result_mmseqs2_strand_summary_V.bed /beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes/houghia_brevipilosa.fna --latency-wait 5 \
 --attempt 1 --force-use-threads --scheduler greedy \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules Extract_translate_loci --nocolor --notemp --no-hooks --nolock --scheduler-solver-path /beegfs/data/bguinet/Bguinet_conda/bin \
--mode 2  && touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.9ty3gxst/85.jobfinished || (touch /beegfs/data/soukkal/StageM2/Scripts/Homology_search/.snakemake/tmp.9ty3gxst/85.jobfailed; exit 1)

