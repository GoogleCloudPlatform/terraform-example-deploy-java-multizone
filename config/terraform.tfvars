availability_type = "REGIONAL"
firewall_source_ranges = [
  //Health check service ip
  "130.211.0.0/22",
  "35.191.0.0/16",
  // Public to network
  "0.0.0.0/0",
]