use "wallaroo"
use "wallaroo/generic_app_components"
use "wallaroo/source"
use "wallaroo/tcp_sink"
use "wallaroo/tcp_source"
use "wallaroo/topology"

actor Main
  new create(env: Env) =>
    try

      let powers_of_2_partition = Partition[U64, U64](
        PowersOfTwoPartitionFunction, PowersOfTwo())
      let powers_of_2_partition2 = Partition[U64, U64](
        PowersOfTwoPartitionFunction2, PowersOfTwo())

      let application = recover val
        Application(
          "single_stream-partitioned-state_partition-state_partition_app")
          .new_pipeline[U64, U64]("U64 Counter",
            TCPSourceConfig[U64].from_options(U64Decoder,
              TCPSourceConfigCLIParser(env.args)(0)))
            .to_state_partition[U64 val, U64 val, U64, U64Counter](
              UpdateU64Counter, U64CounterBuilder,
              "counter-state",
              powers_of_2_partition where multi_worker = true)
            .to_state_partition[U64 val, U64 val, U64, U64Counter](
              UpdateU64Counter2, U64CounterBuilder,
              "counter-state 2",
              powers_of_2_partition2 where multi_worker = true)
            .to_sink(TCPSinkConfig[U64].from_options(
              FramedU64Encoder,
              TCPSinkConfigCLIParser(env.args)(0)))
      end
      Startup(env, application,
        "single_stream-partitioned-state_partition-state_partition_app")
    else
      @printf[I32]("Couldn't build topology\n".cstring())
    end