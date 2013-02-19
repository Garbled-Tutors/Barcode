require 'prawn'
require "barby"
require "barby/outputter/prawn_outputter" 

class HomeController < ApplicationController

  def index
    #@pdf = Prawn::Document.new(:page_size => [185, 172], :margin => [4, 4]) 
    @pdf = Prawn::Document.new(:page_size => [185, 72], :margin => [4, 4]) 
    create_report(0,0,'12345678')
    @pdf.render_file('prawn.pdf')
  end

  def create_report(x_offset,y_offset,barcodeid)
    write_basic_data(x_offset,y_offset,barcodeid)
    generate_bar_code(y_offset,x_offset,barcodeid)
  end

  def write_basic_data(x_offset,y_offset,barcodeid)
    @pdf.bounding_box [x_offset,64 +y_offset], :width => 140, :height => 70 do
      @pdf.text 'Jones, Bob', :size => 10
      @pdf.move_down(2)
      @pdf.text "  8/12/75", :size =>8
      @pdf.move_down(2)
      @pdf.text "  Accountant", :size =>8
      @pdf.move_down(2)
      @pdf.text "  M 25", :size =>8
      @pdf.move_down(3)
      @pdf.text barcodeid, :size => 10
    end
  end

  def generate_bar_code(x_offset,y_offset,barcodeid)
    #barcodeid must be even number of digits for Code25Interleaved
    @pdf.rotate(270)

    @pdf.save_graphics_state
    @pdf.scale 0.5
    barcode = Barby::Code25Interleaved.new(barcodeid)
    barcode.annotate_pdf(@pdf,:height=>20, :xdim => 1, :x=> -92 - x_offset,:y=> y_offset + 152)
    @pdf.restore_graphics_state


    #barcode = Barby::Code25Interleaved.new(barcodeid)
    #barcode.annotate_pdf(@pdf,:height=>20, :xdim => 0.5, :x=> -72 - x_offset,:y=> y_offset + 152)
    #@pdf.draw_text(barcodeid, :size =>4, :at => [-60-x_offset,148+y_offset])
    @pdf.rotate(90)
  end

  #            Test methods used to find coordinates of new objects
  def draw_center_x(x,y)
    @pdf.fill_color "ff0000" 
    @pdf.draw_text("X", :size =>10, :at => [x,y])
  end

  def draw_prawn_grid_dots(xcenter,ycenter)
    draw_center_x(xcenter,ycenter)
    @pdf.fill_color "0000ff" 
    y = -50 + ycenter
    while y < (50 + ycenter)
      x = -50 + xcenter
      while x < (50 + xcenter)
        @pdf.draw_text(".", :size =>4, :at => [x,y])
        x += 10
      end
      y += 10
    end
    @pdf.fill_color "000000" 
  end

  def draw_prawn_grid(xcenter, ycenter)
    draw_prawn_grid_dots(xcenter, ycenter)
    @pdf.fill_color "0000ff" 
    y = -500 + ycenter
    while y < (500 + ycenter)
      x = -500 + xcenter
      while x < (500 + xcenter)
        @pdf.draw_text("#{x},#{y}", :size =>4, :at => [x,y])
        x += 50
      end
      y += 50
    end
    @pdf.fill_color "000000" 
  end
end
