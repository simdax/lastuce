#! /usr/bin/ruby
# -*- coding: utf-8 -*-

# $fichier=ARGV[0]
# if $fichier==nil then
# puts "veuillez entrer l'emplacement de votre texte"
# exit
# end

$fichier="textes/lastuce"
 
require 'rubySC'
require 'gosu'
include Gosu
require 'chingu'
include Chingu


class Main < Chingu::Window

  attr_accessor :image

  def initialize
    super 1000, 1000

    SC.demarrer
    @phrase=File.open($fichier).readlines
    
    @index=0

    @texte=Text.create(@phrase[@index], :x => 50, :y=>50, :max_width => $window.width/2-50, :factor => 2)
    self.input=[:space, :escape, :b]
    
    @images=Hash.new

  end
  
  def apparition image
   @thr= Thread.new do 
      15.times do 
        image.alpha += 8 unless image.alpha >= 100
        sleep 0.2
      end
    end
  end

  def escape
    self.close
    SC.quit
  end

  def space
    @index +=1 unless @index == @phrase.length - 1
    if self.check then
      self.space end
  end
  
  def b
    @index -=1 unless @index == 0 
    if self.check then
      self.b end
  end
    
  def update
    @texte.text=@phrase[@index]
  end

  def check

    phraseAct=@phrase[@index]
    phraseSansDebut=phraseAct[1..-1].chomp

    case phraseAct[0]

    when "§" 
      x=1
      Thread.new do
        20.times do
          eval phraseSansDebut
        end
      end
      return true

    when "|"
      ## un peu joker, permet d'évaluer une ligne ruby
      eval phraseSansDebut
      return true

    when "@"

      tmp = @images[phraseSansDebut] = GameObject.create(:x => 500, :y => 500) 
      tmp.image="images/"+phraseSansDebut

      unless @thr.nil? then @thr.kill end
      self.apparition tmp
      return true

    when "`" 

      @images[phraseSansDebut] = GameObject.create(:x => 500, :y => 500)
      @images[phraseSansDebut].image="images/"+phraseSansDebut
      
    when "~"
      ## son...
      SoundFile.charger "sons/"+phraseSansDebut, 0.05
      return true

      
    else return false
      
    end
  end
end




