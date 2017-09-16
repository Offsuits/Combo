module.exports = {
  migrations_directory: "./migrations",
  networks: {
    development: {
      host: "http://ec2-52-15-101-99.us-east-2.compute.amazonaws.com",
      port: 8545,
      network_id: "*" // Match any network id
    }
  }
};
