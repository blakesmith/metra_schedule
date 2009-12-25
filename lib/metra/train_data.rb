module MetraSchedule
  module TrainData
    attr_reader :LINES

    LINES = {
    :up_nw => {
      :name => "Union Pacific Northwest", 
      :url => 'http://metrarail.com/metra/en/home/maps_schedules/metra_system_map/up-nw/schedule.full.html',
      :stations => [
        :ogilve,
        :clyborn,
        :irving_park,
        :jefferson_park,
        :gladstone_park,
        :norwood_park,
        :edison_park,
        :park_ridge,
        :dee_road,
        :des_plaines,
        :cumberland,
        :mount_prospect,
        :arlington_heights,
        :arlington_park,
        :palatine,
        :barrington,
        :fox_river_grove,
        :cary,
        :pingree_road,
        :crystal_lake,
        :woodstock,
        :mchenry,
        :harvard
      ],
      :tables => {:weekday_inbound => 0..1, :saturday_inbound => 2, :sunday_inbound => 3, \
        :weekday_outbound => 4..6, :saturday_outbound => 7, :sunday_outbound => 8 }
    }
  }
  end
end
