require 'plist'

class PlistParser
  PLIST_FILE_PATH = File.expand_path('../../display_info.plist', __FILE__)

  def initialize(file_path = PLIST_FILE_PATH)
    @plist_file = plist_file(file_path)
    @data = parsed_data
  end

  def print
    @data.each do |item|
      puts <<-END
Chipset Model: #{item[:model]}
VRAM: #{item[:vram]}
Displays:
      END
      item[:displays].each_with_index do |display, index|
        puts <<-END
  ##{index + 1}:
    Display Model: #{display[:model]}
    Resolution: #{display[:resolution]}
        END
      end
    end
  end

  private

  def parsed_data
    @plist_file[0]['_items'].map do |item_node|
      {
        model: item_node['sppci_model'],
        vram: item_node['spdisplays_vram_shared'],
        displays: displays_info(item_node['spdisplays_ndrvs'])
      }
    end
  end

  def displays_info(displays)
    displays.map do |display_node|
      { model: display_node['_name'],
        resolution: display_node['_spdisplays_resolution'] }
    end
  end

  def plist_file(file_path)
    Plist.parse_xml(file_path)
  end
end
