desc "Importar diputados de diputados.gob.mx"
task :import_members => :environment do
  require 'nokogiri'
  require 'open-uri'
  require 'date'
  
  party_ids = [1,2,3,4,5,6,12]
  base_url = "http://sitl.diputados.gob.mx/LXI_leg/"
  
  def self.date(text)
    day, month, year = text.split('-')
    month = case month
            when "enero" then 1
            when "febrero" then 2
            when "marzo" then 3
            when "abril" then 4
            when "mayo" then 5
            when "junio" then 6
            when "julio" then 7
            when "agosto" then 8
            when "septiembre" then 9
            when "octubre" then 10
            when "noviembre" then 11
            when "diciembre" then 12
            else Rails.logger.debug "Fecha erronea #{text}"
            end
    begin
      return Date.new(year.to_i, month, day.to_i)
    rescue
      return nil
    end
  end
  
  def self.party_id(id)
    party_id = case id
               when 1 then 1
               when 2 then 3
               when 3 then 2
               when 4 then 4
               when 5 then 5
               when 6 then 6
               when 12 then 7
               else Rails.logger.debug "Party ID erroneo: #{id}"
               end
    return party_id
  end
  
  party_ids.each do |id|
    url = "http://sitl.diputados.gob.mx/LXI_leg/listado_diputados_gpnp.php?tipot=#{id}"
    doc = Nokogiri::HTML(open(url))
    puts doc.at_css("title").text

    doc.css(".linkVerde").each do |link|
      member_doc = doc = Nokogiri::HTML(open(base_url+link[:href]))
      name = member_doc.at_css(".textoNegro:nth-child(3) .Estilo67").text.strip.gsub('Dip. ', '').strip
      state_name = member_doc.at_css("td tr:nth-child(3) td:nth-child(2)").text.strip
      election = member_doc.at_css("tr:nth-child(2) :nth-child(2)").text.strip #.split(' ').map {|w| w.capitalize!}.join(' ')
      election = "Representación Proporcional" if election == "Representación proporcional"
      district_number = member_doc.at_css("td tr:nth-child(4) td:nth-child(2)").text.strip
      head = member_doc.at_css("tr:nth-child(5) td:nth-child(2)").text
      curul = member_doc.at_css("td tr:nth-child(6) td:nth-child(2)").text.strip
      birthdate = date(member_doc.at_css("td tr:nth-child(8) td").text.gsub('Fecha de Nacimiento:', '').strip)
      substitute = member_doc.at_css("tr:nth-child(7) .Estilo67").text.gsub('Suplente: ', '').strip
      email = member_doc.at_css(".textoNegro .linkNegroSin").text.strip
      official_id = link[:href].split('=').last.to_i
      puts "#{name}, #{state_name}, #{district_number}, #{head}, #{curul}, #{birthdate}, #{election}, #{substitute}, #{email}, #{official_id}"
      
      state = State.find_by_name(state_name)
      puts "State: #{state.inspect}, (#{state_name})"
      
      district = District.find(:first, :conditions => ["state_id = ? AND number = ?", state.id, district_number])
      puts "District: #{district.inspect}, (#{district_number})"
      
      
      member = Member.new(:name => name, :email => email, :election => election, :birthdate => birthdate, :substitute => substitute,
                          :party_id => party_id(id), :state => state, :curul => curul, :official_id => official_id)
      member.district = district if member.elected? && district
      member.complete = member.valid?
      member.save(false)
      
    end
  end
end

desc "Importar fotos de diputados"
task :import_fotos => :environment do
  require 'nokogiri'
  require 'open-uri'
  
  Member.all.each do |member|
    begin
      url = "http://sitl.diputados.gob.mx/LXI_leg/curricula.php?dipt=#{member.official_id}"
      doc = Nokogiri::HTML(open(url))
    
      foto_id = doc.at_css("tr:nth-child(1) td:nth-child(1) img")[:src][/[0-9]+/]
      foto_url = "http://sitl.diputados.gob.mx/LXI_leg/fotos_lxi/"+foto_id+".jpg"
    
      puts "Member ID: #{member.id}, #{foto_url}"
    
      temp = open(foto_url)
      member.picture = temp
      member.save(false)
    rescue OpenURI::HTTPError
      puts "No se encontró la foto del Member ID: #{member.id}, #{foto_url}"
    end
  end
end