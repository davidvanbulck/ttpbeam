#!/bin/bash

# Loop through each XML file in the directory
xml_dir="InstancesXML"
output_dir="JobScripts"

# Make sure the output directory exists
mkdir -p "$output_dir"

for xml_file in "$xml_dir"/*.xml; do
	# Extract the base filename without the path and extension
	base_name="$(basename "$xml_file" .xml)"

	# Skip files that start with "TSP"
	if [[ $base_name == TSP* ]]; then
		continue
	fi

	# Define the output filename
	output_file="$output_dir/Job_${base_name}.sh"

	# Write the content to the output file
	cat > "$output_file" << EOF
# Request wall time and nodes
#PBS -l walltime=7200
# Reserve two processors, just to be sure that it gets enough free space (memory requirements are very high anyway)
#PBS -l nodes=1:ppn=1
# Note PMEM is memory per node. Max possible is 4 GB per node
#PBS -l mem=125gb

module load SciPy-bundle
module load Julia

cd /data/gent/vo/001/gvo00147/vsc41980/TTP/ttpbeam
julia ttp_beam_search_ortools_iter.jl $xml_dir/${base_name}.xml 3 true 3600 10 327680 2 true random none 0.001 2 true -1
EOF

	qsub $output_file
done


