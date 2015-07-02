module Textage
  extend ActiveSupport::Concern
  CONVERT = {
    '[5th]'  => 5,
    '[6th]'  => 6,
    '[7th]'  => 7,
    '[8th]'  => 8,
    '[9th]'  => 9,
    '[10th]' => 10,
    '[RED]'  => 11,
    '[SKY]'  => 12,
    '[DD]'   => 13,
    '[GOLD]' => 14,
    '[DJT]'  => 15,
    '[EMP]'  => 16,
    '[SIR]'  => 17,
    '[RA]'   => 18,
    '[LC]'   => 19,
    '[tri]'  => 20,
    '[SPA]'  => 21,
    '[PEN]'  => 22
  }

  included do
    def self.textage(array)
      array.each { |elem| attributes_by_textage(elem) }
    end

    private

    def self.attributes_by_textage(elem)
      sheet = find_by("title = #{elem[:title]} OR textage = #{elem[:link]}")
      if sheet
        sheet.update(textage: elem[:link])
      else
        sheet_params = {
          title: elem[:title],
          version: CONVERT[elem[:version]],
          n_ability: 19,
          h_ability: 19,
          active: true,
          textage: elem[:link]
        }
        Sheet.create(sheet_params)
      end
    end
  end
end
