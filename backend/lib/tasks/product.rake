require 'highline/import'
require 'colorize'

namespace :product do
    desc "Add credit to specific user"
    task add: :environment do

        begin            
            system("clear")
            code = ask("product code : ")            
            if code.blank?
                printf "No code given....Arrivederci!".colorize(color: :white, background: :red)
                exit
            end

            name = ask("product name : ")            
            if code.blank?
                printf "No name given....Arrivederci!".colorize(color: :white, background: :red)
                exit
            end

            price = ask("product price : ")   
            if price.to_f.zero? || price.to_f.negative?
                printf "invalid price ....Arrivederci!".colorize(color: :white, background: :red)
                exit
            end

            begin
              ActiveRecord::Base.transaction do
                Product.create!(code: code.to_s, name: name, price: price.to_f)    
              end
              printf "product created !!".colorize(color: :white, background: :green)
            rescue ActiveRecord::RecordInvalid => exception
              printf exception.message.colorize(color: :white, background: :red)
            end    
        rescue => exception
            p "exception found : #{exception.message}"
        end


    end
  end