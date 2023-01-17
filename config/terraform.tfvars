availability_type = "REGIONAL"
internal_addresses = [
  "10.138.0.7",
  "10.138.0.8",
] //make sure the the IP addresses must be "inside" the region default subnetwork
firewall_source_ranges = [
  //Health check service ip
  "130.211.0.0/22",
  "35.191.0.0/16",
  // Public to network
  "0.0.0.0/0",
]