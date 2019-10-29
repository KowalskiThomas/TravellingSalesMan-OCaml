start=$(date +%s.%N); \
  sleep 0.1s; \
  dur=$(echo "$(date +%s.%N) - $start" | bc); \
  printf "Execution time: %.6f seconds\n" $dur