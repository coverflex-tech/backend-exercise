require 'highline/import'
require 'colorize'

namespace :credit do
    desc "Add credit to specific user"
    task add: :environment do

        begin            
            system("clear")
            username = ask("type the username : ")            
            if username.blank?
                printf "No user given....Arrivederci!".colorize(color: :white, background: :red)
                exit
            end

            user = User.find_by(username: username)            
            if user.nil?
                printf "invalid user #{username} ....Arrivederci!".colorize(color: :white, background: :red)
                exit
            end
            
            amount = ask("what is the amount : ")   
            if amount.to_f.zero? || amount.to_f.negative?
                printf "invalid amount ....Arrivederci!".colorize(color: :white, background: :red)
                exit
            end

            begin
              ActiveRecord::Base.transaction do
                user.balances.create!(user_id: user.id, amount: amount.to_f)      
              end
              printf "credit added !!".colorize(color: :white, background: :green)
            rescue ActiveRecord::RecordInvalid => exception
              printf exception.message.colorize(color: :white, background: :red)
            end    
        rescue => exception
            p "exception found : #{exception.message}"
        end


    end
  end