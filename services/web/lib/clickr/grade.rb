class Clickr::Grade
  GRADING_TABLE =
    [
      [98..100, '1+'],
      [95...98, '1'],
      [92...95, '1-'],
      [87...92, '2+'],
      [82...87, '2'],
      [77...82, '2-'],
      [72...77, '3+'],
      [68...72, '3'],
      [62...68, '3-'],
      [57...62, '4+'],
      [52...57, '4'],
      [47...52, '4-'],
      [42...47, '5+'],
      [37...42, '5'],
      [25...37, '5-'],
      [0...25, '6']
    ].flat_map { |range, grade| range.to_a.map { |p| [p, grade] } }.to_h.freeze

  def self.from_percentage(percentage)
    GRADING_TABLE[(100.0 * percentage).floor]
  end
end
