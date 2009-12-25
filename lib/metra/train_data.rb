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
    },
    :up_n => {
      :name => "Union Pacific North",
      :url => 'http://metrarail.com/metra/en/home/maps_schedules/metra_system_map/up-n/schedule.full.html',
      :stations => [
        :ogilve,
        :clyborn,
        :ravenswood,
        :rogers_park,
        :evanston_main_street,
        :evanston_davis_street,
        :evanston_central_street,
        :wilmette,
        :kenilworth,
        :indian_hill,
        :winnetka,
        :hubbard_woods,
        :glencoe,
        :braeside,
        :ravinia_park,
        :ravinia,
        :highland_park,
        :highwood,
        :fort_sheridan,
        :lake_forest,
        :lake_bluff,
        :greate_lakes,
        :north_chicago,
        :waukegan,
        :zion,
        :winthrop_harbor,
        :kenosha
      ],
      :tables => {:weekday_inbound => 0..2, :saturday_inbound => 3, :sunday_inbound => 4, \
        :weekday_outbound => 5..7, :saturday_outbound => 8, :sunday_outbound => 9 }
    },
    :ncs => {
      :name => "North Central Service",
      :url => 'http://metrarail.com/metra/en/home/maps_schedules/metra_system_map/ncs/schedule.full.html',
      :stations => [
        :union_station,
        :western_avenue,
        :river_grove,
        :franklin_park,
        :schiller_park,
        :rosemont,
        :ohare_transfer,
        :prospect_heights,
        :wheeling,
        :buffalo_grove,
        :prairie_view,
        :vernon_hills,
        :mundelein,
        :libertyville,
        :grayslake,
        :round_lake_beach,
        :lake_villa,
        :antioch
      ],
      :tables => {:weekday_inbound => 0, :weekday_outbound => 1 }
    },
    :md_w => {
      :name => "Milwaukee District West",
      :url => 'http://metrarail.com/metra/en/home/maps_schedules/metra_system_map/md-w/schedule.full.html',
      :stations => [
        :union_station,
        :western_avenue,
        :grand_cicero,
        :hanson_park,
        :galewood,
        :mars,
        :mont_clare,
        :elmwood_park,
        :river_park,
        :franklin_park,
        :mannheim,
        :bensenville,
        :wood_dale,
        :itasca,
        :medinah,
        :roselle,
        :schaumburg,
        :hanover_park,
        :bartlett,
        :national_street,
        :elgin,
        :big_timber
      ],
      :tables => {:weekday_inbound => 0..1, :saturday_inbound => 2, :sunday_inbound => 3, \
        :weekday_outbound => 4..5, :saturday_outbound => 6, :sunday_outbound => 7 }
    },
    :up_w => {
      :name => "Union Pacific West",
      :url => 'http://metrarail.com/metra/en/home/maps_schedules/metra_system_map/up-w/schedule.full.html',
      :stations => [
        :ogilve,
        :kedzie,
        :oak_park,
        :river_forest,
        :maywood,
        :melrose_park,
        :bellwood,
        :berkeley,
        :elmhurst,
        :villa_park,
        :lombard,
        :glen_ellyn,
        :college_avenue,
        :wheaton,
        :winfield,
        :west_chicago,
        :geneva,
        :la_fox,
        :elburn
      ],
      :tables => {:weekday_inbound => 0..1, :saturday_inbound => 2, :sunday_inbound => 3, \
        :weekday_outbound => 4..5, :saturday_outbound => 6, :sunday_outbound => 7 }
    },
    :bnsf => {
      :name => "BNSF Railway",
      :url => 'http://metrarail.com/metra/en/home/maps_schedules/metra_system_map/bnsf/schedule.full.html',
      :stations => [
        :union_station,
        :halsted,
        :western_avenue,
        :cicero,
        :lavergne,
        :berwyn,
        :harlem_ave,
        :riverside,
        :hollywood,
        :brookfield,
        :congress_park,
        :lagrange_road,
        :lagrange_stone_avenue,
        :western_springs,
        :highlands,
        :hinsdale,
        :west_hinsdale,
        :clarendon_hills,
        :westmont,
        :fairview_avenue,
        :downers_grove_main_street,
        :belmont,
        :lisle,
        :naperville,
        :route_59,
        :aurora
      ],
      :tables => {:weekday_inbound => 0..2, :saturday_inbound => 3, :sunday_inbound => 4, \
        :weekday_outbound => 5..7, :saturday_outbound => 8, :sunday_outbound => 9 }
    },
    :hc => {
      :name => "Heritage Corridor",
      :url => 'http://metrarail.com/metra/en/home/maps_schedules/metra_system_map/hc/schedule.full.html',
      :stations => [
        :union_station,
        :summit,
        :willow_springs,
        :lemont,
        :lockport,
        :joliet
      ],
      :tables => {:weekday_inbound => 0, :weekday_outbound => 1 }
    }
  }
  end
end
