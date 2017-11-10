#Ruby

require 'fox16'
require 'fox16/canvas'
include Fox
include Canvas

class Iterators
    def initialize
    end 

    def swapper (s,a,b)
    #takes in a string (s) and two array positions (a and b)
    #then swaps the two elements and outputs the result.
        swapped = s.map.with_index do |x,i| 
            if i == a 
                s[b] 
            elsif i == b 
                s[a] 
            else x 
            end
        end
        return swapped
    end

    def swap_iterator (ari)
        #creates an array of all possible swaps
        swaplist = []
        (((0..11).to_a).combination(2).to_a).each do |x,y| 
            swaplist.push(swapper(ari,x,y))
        end
        #puts swaplist.length
        return swaplist
    end

    def injecter (a,b,arin)
        #takes an element from an array (a) and sticks it somewhere else in the array (b).
        inj = arin.values_at(0...a, (a+1)..-1)
        inj.insert(b, arin[a])
    end

    def injecter_iterator (ari)
        #Creates an array of all possible injections.
        swaplist = []
        (((0...11).to_a).combination(2).to_a).each do |x,y| 
            swaplist.push(injecter(x,y,ari))
            #puts "x: #{x} y: #{y} ari: #{ari}"
        end
        return swaplist
    end
    def rotator_iterator (ari)
        rot_list = []
        for vv in 1...ari.length
            rot_list.push(ari.rotate(vv))
        end
        return rot_list
    end

    def transposer_iterator (ari)
        tranout = []
        for zz in 1...12
            tran = []
            ari.each do |xx|
                tran.push((xx + zz) % 12)
            end
            tranout.push(tran)
        end
        return tranout
    end

    def flipper_iterator (ari)
        return [ari.reverse]
    end
end

class TwelveTone < FXMainWindow
  def initialize(app)
    super(app, "Dodecafinder by David Pocknee", :width => 720, :height => 750)

@intervalcheck1 = { "type" => "harmonic", "value" => 0.0} #options: harmonic (direction independent)/melodic (direction dependent)
@primecheck1 = { "3" => 1, "4" => 1, "5" => 1, "6" => 1, "7" => 1, "8" => 1, "9" => 1, "10" => 1, "11" => 1 }
@retrogradecheck1 = { "3" => 1, "4" => 1, "5" => 1, "6" => 1, "7" => 1, "8" => 1, "9" => 1, "10" => 1, "11" => 1 }
@invertedcheck1 = { "3" => 1, "4" => 1, "5" => 1, "6" => 1, "7" => 1, "8" => 1, "9" => 1, "10" => 1, "11" => 1 }
@retroinvertedcheck1 = { "3" => 1, "4" => 1, "5" => 1, "6" => 1, "7" => 1, "8" => 1, "9" => 1, "10" => 1, "11" => 1 }
@totalsymcheck1 = { "3" => 0, "4" => 0, "5" => 0, "6" => 0, "7" => 1, "8" => 1, "9" => 1, "10" => 1, "11" => 1 }
@pcsetcheck1 = { "3" => 1, "4" => 1, "5" => 1, "6" => 1, "7" => 1, "8" => 1, "9" => 1, "10" => 1, "11" => 1 }
@pearsoncheck1 = { "pearson" => 0.0}
# 1=upward slope, -1=downward slope, 0=no relation


@weighting1 = {
  "interval" => 1.0,
  "prime" => 1.0,
  "retrograde" => 1.0,
  "inverted" => 1.0,
  "retroinverted" => 1.0,
  "totalsym" => 1.0,
  "pcset" => 1.0,
  "pearson" => 1.0
}

@onoff = {
  "interval" => false,
  "prime" => false,
  "retrograde" => false,
  "inverted" => false,
  "retroinverted" => false,
  "totalsym" =>false,
  "pcset" => false,
  "pearson" => false
}

@totalsymtype = {"prime" => true,
                 "retrograde" => false,
                 "inverted" => true,
                 "retroinverted" => true}


#HEADER
    hFrame1 = FXVerticalFrame.new(self)
   FXLabel.new(hFrame1, "This programme uses a genetic algorithm to find optimal 12-tone rows that fit a given set of criteria.")
   FXLabel.new(hFrame1, "All values should be between 0 and 1, or left blank, if ignored.")
    FXHorizontalSeparator.new(self,
      LAYOUT_SIDE_TOP|SEPARATOR_GROOVE|LAYOUT_FILL_X)

#MAIN BODY
    matrix1 = FXMatrix.new(self, 3, MATRIX_BY_COLUMNS|LAYOUT_SIDE_TOP|LAYOUT_FILL_X)

    @poolsize1 = FXDataTarget.new(15)
    @generations1 = FXDataTarget.new(12)
    @avamount1 = FXDataTarget.new(100)


#INTERVAL
    intervalframe1 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXCheckButton.new(intervalframe1, "Intervallic Reptition", nil).connect(SEL_COMMAND) { @onoff["interval"] ^= true }
    intervalframe2 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    groupbox = FXGroupBox.new(intervalframe2, "Type of intervals",
      :opts => GROUPBOX_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_Y)
    @radio1 = FXRadioButton.new(groupbox, "Harmonic")
    @radio1.connect(SEL_COMMAND) { @choice = 0 }
    @radio1.connect(SEL_UPDATE) { @radio1.checkState = (@choice == 0) }    
    @radio2 = FXRadioButton.new(groupbox, "Melodic")
    @radio2.connect(SEL_COMMAND) { @choice = 1}
    @radio2.connect(SEL_UPDATE) { @radio2.checkState = (@choice == 1)}
    @choice = 0
    @radio1.checkState = true    
    intervalframe2b = FXHorizontalFrame.new(intervalframe2, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    intervalframe2c = FXVerticalFrame.new(intervalframe2b)
    FXLabel.new(intervalframe2c, "Repeated Intervals (0-1):", nil)
    @intervalcheck1["value"] = FXTextField.new(intervalframe2b, 3)
    intervalframe3 = FXVerticalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXLabel.new(intervalframe3, "Weighting", nil)
    @weighting1["interval"] = FXTextField.new(intervalframe3, 3)

#PRIME
    primeframe1 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXCheckButton.new(primeframe1, "Prime Symmetry", nil).connect(SEL_COMMAND) { @onoff["prime"] ^= true }
    primeframe2 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXLabel.new(primeframe2, "3", nil)
    @primecheck1["3"] = FXTextField.new(primeframe2, 3)
    FXLabel.new(primeframe2, "4", nil)
    @primecheck1["4"] = FXTextField.new(primeframe2, 3)#.value
    FXLabel.new(primeframe2, "5", nil)
    @primecheck1["5"] = FXTextField.new(primeframe2, 3)
    FXLabel.new(primeframe2, "6", nil)
    @primecheck1["6"] = FXTextField.new(primeframe2, 3)
    FXLabel.new(primeframe2, "7", nil)
    @primecheck1["7"] = FXTextField.new(primeframe2, 3)
    FXLabel.new(primeframe2, "8", nil)
    @primecheck1["8"] = FXTextField.new(primeframe2, 3)
    FXLabel.new(primeframe2, "9", nil)
    @primecheck1["9"] = FXTextField.new(primeframe2, 3)
    FXLabel.new(primeframe2, "10", nil)
    @primecheck1["10"] = FXTextField.new(primeframe2, 3)
    FXLabel.new(primeframe2, "11", nil)
    @primecheck1["11"] = FXTextField.new(primeframe2, 3)
    primeframe3 = FXVerticalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    @weighting1["prime"] = FXTextField.new(primeframe3, 3)

# RETROGRADE
    retrogradeframe1 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXCheckButton.new(retrogradeframe1, "Retrograde Symmetry", nil).connect(SEL_COMMAND) { @onoff["retrograde"] ^= true }
    retrogradeframe2 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXLabel.new(retrogradeframe2, "3", nil)
    @retrogradecheck1["3"] = FXTextField.new(retrogradeframe2, 3)
    FXLabel.new(retrogradeframe2, "4", nil)
    @retrogradecheck1["4"] = FXTextField.new(retrogradeframe2, 3)
    FXLabel.new(retrogradeframe2, "5", nil)
    @retrogradecheck1["5"] = FXTextField.new(retrogradeframe2, 3)
    FXLabel.new(retrogradeframe2, "6", nil)
    @retrogradecheck1["6"] = FXTextField.new(retrogradeframe2, 3)
    FXLabel.new(retrogradeframe2, "7", nil)
    @retrogradecheck1["7"] = FXTextField.new(retrogradeframe2, 3)
    FXLabel.new(retrogradeframe2, "8", nil)
    @retrogradecheck1["8"] = FXTextField.new(retrogradeframe2, 3)
    FXLabel.new(retrogradeframe2, "9", nil)
    @retrogradecheck1["9"] = FXTextField.new(retrogradeframe2, 3)
    FXLabel.new(retrogradeframe2, "10", nil)
    @retrogradecheck1["10"] = FXTextField.new(retrogradeframe2, 3)
    FXLabel.new(retrogradeframe2, "11", nil)
    @retrogradecheck1["11"] = FXTextField.new(retrogradeframe2, 3)
    retrogradeframe3 = FXVerticalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    @weighting1["retrograde"] = FXTextField.new(retrogradeframe3, 3)

# INVERTED
    invertedframe1 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXCheckButton.new(invertedframe1, "Inverted Symmetry", nil).connect(SEL_COMMAND) { @onoff["inverted"] ^= true }
    invertedframe2 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXLabel.new(invertedframe2, "3", nil)
    @invertedcheck1["3"] = FXTextField.new(invertedframe2, 3)
    FXLabel.new(invertedframe2, "4", nil)
    @invertedcheck1["4"] = FXTextField.new(invertedframe2, 3)
    FXLabel.new(invertedframe2, "5", nil)
    @invertedcheck1["5"] = FXTextField.new(invertedframe2, 3)
    FXLabel.new(invertedframe2, "6", nil)
    @invertedcheck1["6"] = FXTextField.new(invertedframe2, 3)
    FXLabel.new(invertedframe2, "7", nil)
    @invertedcheck1["7"] = FXTextField.new(invertedframe2, 3)
    FXLabel.new(invertedframe2, "8", nil)
    @invertedcheck1["8"] = FXTextField.new(invertedframe2, 3)
    FXLabel.new(invertedframe2, "9", nil)
    @invertedcheck1["9"] = FXTextField.new(invertedframe2, 3)
    FXLabel.new(invertedframe2, "10", nil)
    @invertedcheck1["10"] = FXTextField.new(invertedframe2, 3)
    FXLabel.new(invertedframe2, "11", nil)
    @invertedcheck1["11"] = FXTextField.new(invertedframe2, 3)
    invertedframe3 = FXVerticalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    @weighting1["inverted"] = FXTextField.new(invertedframe3, 3)

# RETROINVERTED
    retroinvertedframe1 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXCheckButton.new(retroinvertedframe1, "Retrograde Inverted Symmetry", nil).connect(SEL_COMMAND) { @onoff["retroinverted"] ^= true }
    retroinvertedframe2 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXLabel.new(retroinvertedframe2, "3", nil)
    @retroinvertedcheck1["3"] = FXTextField.new(retroinvertedframe2, 3)
    FXLabel.new(retroinvertedframe2, "4", nil)
    @retroinvertedcheck1["4"] = FXTextField.new(retroinvertedframe2, 3)
    FXLabel.new(retroinvertedframe2, "5", nil)
    @retroinvertedcheck1["5"] = FXTextField.new(retroinvertedframe2, 3)
    FXLabel.new(retroinvertedframe2, "6", nil)
    @retroinvertedcheck1["6"] = FXTextField.new(retroinvertedframe2, 3)
    FXLabel.new(retroinvertedframe2, "7", nil)
    @retroinvertedcheck1["7"] = FXTextField.new(retroinvertedframe2, 3)
    FXLabel.new(retroinvertedframe2, "8", nil)
    @retroinvertedcheck1["8"] = FXTextField.new(retroinvertedframe2, 3)
    FXLabel.new(retroinvertedframe2, "9", nil)
    @retroinvertedcheck1["9"] = FXTextField.new(retroinvertedframe2, 3)
    FXLabel.new(retroinvertedframe2, "10", nil)
    @retroinvertedcheck1["10"] = FXTextField.new(retroinvertedframe2, 3)
    FXLabel.new(retroinvertedframe2, "11", nil)
    @retroinvertedcheck1["11"] = FXTextField.new(retroinvertedframe2, 3)
    retroinvertedframe3 = FXVerticalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    @weighting1["retroinverted"] = FXTextField.new(retroinvertedframe3, 3)

# TOTAL SYMMETRY
    totalsymframe1 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXCheckButton.new(totalsymframe1, "Total Symmetry", nil).connect(SEL_COMMAND) { @onoff["totalsym"] ^= true }
    totalsymframe2a = FXVerticalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    totalsymframe2b = FXHorizontalFrame.new(totalsymframe2a, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXCheckButton.new(totalsymframe2b, "Prime", nil).connect(SEL_COMMAND) { @totalsymtype["prime"] ^= true } 
    FXCheckButton.new(totalsymframe2b, "Retrograde", nil).connect(SEL_COMMAND) { @totalsymtype["retrograde"] ^= true } 
    FXCheckButton.new(totalsymframe2b, "Inverted", nil).connect(SEL_COMMAND) { @totalsymtype["inverted"] ^= true } 
    FXCheckButton.new(totalsymframe2b, "Retro-inverted", nil).connect(SEL_COMMAND) { @totalsymtype["retroinverted"] ^= true } 
    totalsymframe2 = FXHorizontalFrame.new(totalsymframe2a, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXLabel.new(totalsymframe2, "3", nil)
    @totalsymcheck1["3"] = FXTextField.new(totalsymframe2, 3)
    FXLabel.new(totalsymframe2, "4", nil)
    @totalsymcheck1["4"] = FXTextField.new(totalsymframe2, 3)
    FXLabel.new(totalsymframe2, "5", nil)
    @totalsymcheck1["5"] = FXTextField.new(totalsymframe2, 3)
    FXLabel.new(totalsymframe2, "6", nil)
    @totalsymcheck1["6"] = FXTextField.new(totalsymframe2, 3)
    FXLabel.new(totalsymframe2, "7", nil)
    @totalsymcheck1["7"] = FXTextField.new(totalsymframe2, 3)
    FXLabel.new(totalsymframe2, "8", nil)
    @totalsymcheck1["8"] = FXTextField.new(totalsymframe2, 3)
    FXLabel.new(totalsymframe2, "9", nil)
    @totalsymcheck1["9"] = FXTextField.new(totalsymframe2, 3)
    FXLabel.new(totalsymframe2, "10", nil)
    @totalsymcheck1["10"] = FXTextField.new(totalsymframe2, 3)
    FXLabel.new(totalsymframe2, "11", nil)
    @totalsymcheck1["11"] = FXTextField.new(totalsymframe2, 3)
    totalsymframe3 = FXVerticalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    @weighting1["totalsym"] = FXTextField.new(totalsymframe3, 3)

# PCSET
    pcsetframe1 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXCheckButton.new(pcsetframe1, "PCset Symmetry", nil).connect(SEL_COMMAND) { @onoff["pcset"] ^= true }
    pcsetframe2 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXLabel.new(pcsetframe2, "3", nil)
    @pcsetcheck1["3"] = FXTextField.new(pcsetframe2, 3)
    FXLabel.new(pcsetframe2, "4", nil)
    @pcsetcheck1["4"] = FXTextField.new(pcsetframe2, 3)
    FXLabel.new(pcsetframe2, "5", nil)
    @pcsetcheck1["5"] = FXTextField.new(pcsetframe2, 3)
    FXLabel.new(pcsetframe2, "6", nil)
    @pcsetcheck1["6"] = FXTextField.new(pcsetframe2, 3)
    FXLabel.new(pcsetframe2, "7", nil)
    @pcsetcheck1["7"] = FXTextField.new(pcsetframe2, 3)
    FXLabel.new(pcsetframe2, "8", nil)
    @pcsetcheck1["8"] = FXTextField.new(pcsetframe2, 3)
    FXLabel.new(pcsetframe2, "9", nil)
    @pcsetcheck1["9"] = FXTextField.new(pcsetframe2, 3)
    FXLabel.new(pcsetframe2, "10", nil)
    @pcsetcheck1["10"] = FXTextField.new(pcsetframe2, 3)
    FXLabel.new(pcsetframe2, "11", nil)
    @pcsetcheck1["11"] = FXTextField.new(pcsetframe2, 3)
    pcsetframe3 = FXVerticalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    @weighting1["pcset"] = FXTextField.new(pcsetframe3, 3)

# PEARSON
    pearsonframe1 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    FXCheckButton.new(pearsonframe1, "Direction (Pearson Coefficient)", nil).connect(SEL_COMMAND) { @onoff["pearson"] ^= true }

    pearsonframe2 = FXHorizontalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)   
    pearsonframe2b = FXHorizontalFrame.new(pearsonframe2, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    pearsonframe2c = FXVerticalFrame.new(pearsonframe2b)
    FXLabel.new(pearsonframe2c, "-1 = down, +1 = up, 0 = no correlation", nil)
    @pearsoncheck1["pearson"] = FXTextField.new(pearsonframe2b, 3)
    pearsonframe3 = FXVerticalFrame.new(matrix1, LAYOUT_CENTER_Y|LAYOUT_FILL_COLUMN|LAYOUT_FILL_ROW)
    @weighting1["pearson"] = FXTextField.new(pearsonframe3, 3)

    FXHorizontalSeparator.new(self, LAYOUT_SIDE_TOP|SEPARATOR_GROOVE|LAYOUT_FILL_X)

    lowerframe1 = FXVerticalFrame.new(self, :opts => LAYOUT_FILL)

    outputdrawframe = FXHorizontalFrame.new(lowerframe1, LAYOUT_FILL)
    @textArea = FXText.new(outputdrawframe, :width => 300, :opts => LAYOUT_FILL | TEXT_WORDWRAP)

#ROW VISUALIZATION   
    @drawer = FXDataTarget.new("[0,1,2,3,4,5,6,7,8,9,10,11]")
    @vectorrow = FXDataTarget.new("[Vector Here]")

    bigframe = FXVerticalFrame.new(outputdrawframe, :opts => LAYOUT_FILL_Y) #, :opts => LAYOUT_FILL
    topdiag = FXHorizontalFrame.new(bigframe)   #, LAYOUT_FILL_ROW
    FXTextField.new(topdiag,35, @drawer, FXDataTarget::ID_VALUE)
    drawButton = FXButton.new(topdiag, "Draw Row")

    drawframe = FXHorizontalFrame.new(bigframe, 
      LAYOUT_FILL_X|LAYOUT_FILL_Y|FRAME_SUNKEN|FRAME_THICK,
      0, 0, 0, 0, 0, 0, 0, 0)
    @canvas = ShapeCanvas.new(drawframe, nil, 0, LAYOUT_FILL)#, LAYOUT_FILL_X|LAYOUT_FILL_Y)
    
    @vectortext = FXText.new(bigframe, :selector => FXDataTarget::ID_VALUE, :opts => LAYOUT_FILL_X, :height => 1)
    @vectortext.appendText("[vector here]")
    
    drawButton.connect(SEL_COMMAND) do
      rowconv = stringtovector(@drawer.value.to_s)
      #puts "#{rowconv}"
      @canvas.scene = rowillustrator(@canvas,5,5,4,250,120,rowconv)     
      counttext =  @vectortext.lineEnd(1)
      vectorred = vectorizer(rowconv).to_s
      @vectortext.removeText(0,counttext)
      @vectortext.appendText(vectorred)
      @canvas.update
    end

#BUTTONS    
    buttonframe = FXHorizontalFrame.new(lowerframe1)
    FXLabel.new(buttonframe, "Size of Each Generation:", nil)
    FXTextField.new(buttonframe, 3, @poolsize1, FXDataTarget::ID_VALUE)
    FXLabel.new(buttonframe, "No. of Generations:", nil)
    FXTextField.new(buttonframe, 3, @generations1, FXDataTarget::ID_VALUE)
    generateButton = FXButton.new(buttonframe, "Evolve Optimal Solution")

    FXLabel.new(buttonframe, "No. of average rows sampled:", nil)
    FXTextField.new(buttonframe, 3,  @avamount1, FXDataTarget::ID_VALUE)
    rarityButton = FXButton.new(buttonframe, "Find Rarity")

    generateButton.connect(SEL_COMMAND) do
      accumulator("matches") 
    end

    rarityButton.connect(SEL_COMMAND) do
      accumulator("rarity")    
    end

  end
#ROW VISUALIZATION CODE

  def rowillustrator(canvas,xpos,ypos,size,xsize,ysize,row)
    scene = ShapeGroup.new
    ysplit = ysize/11
    xsplit = xsize/11
    row.map.with_index do |x, i| 
      xpos1 = (xsplit*i)+xpos
      ypos1 = (ysize-(ysplit*x))+ypos
      scene.addShape(CircleShape.new(xpos1, ypos1, size)) 
    end 
    halfcircle = size
    for i in 0...11
      linex1 = (xsplit*i)+xpos+halfcircle
      liney1 = (ysize-(ysplit*row[i]))+ypos+halfcircle
      linex2 = (xsplit*(i+1))+xpos+halfcircle
      #puts "ysize #{ysize} ysplit #{ysplit} row #{row} ypos #{ypos} halfcircle #{halfcircle}"
      liney2 = (ysize-(ysplit*row[i+1]))+ypos+halfcircle
      scene.addShape(LineShape.new(linex1, liney1, linex2, liney2))
    end
    scene
  end

  def stringtovector (string)
    st1 = string.delete '['
    st2 = st1.delete ']'
    st3 = st2.split(",")
    st3.map!{|cc| cc.to_i }
    return st3
  end

#ALGORITHM CODE
    def vectorizer (vectin)
        # This generates the formal vector
        if vectin.length > 1
            vectout = []
            for i in (0...(vectin.length-1))
                vectout.push(vectin[i+1] - vectin[i])
            end
        else
            vectout = []
        end
            return vectout
    end 

    def intervalcomp (vec,type)
        # Takes in an array of vectors (vec), the type of counting ("harmonic"/"melodic")
        # "harmonic" is direction independent (i.e. absolute vector values)
        # "melodic" is direction dependent (i.e. + and - vector values)
        # It calculates the interval repetitions in the row and returns a rating of the number of unique intervals. 
        if type == "melodic"
            ver1 = vec.uniq
        elsif type == "harmonic"
            ver1 = vec.map{|ccc| ccc.abs }.uniq
        end
        verscore = 1-((ver1.length-1)/(vec.length-1).to_f)
        return verscore
    end

    def arrdistance (comp1,comp2,scaling)
        # calculates the absolute distance between the array (comp1) and array (comp2) 
        # Outputs an array of the distances and a value between 0 and 1
        # where (comp2) contains the element x, this is not used for comparison.
        # 1 = identical match, 0 = no match
        #scaling is maximum distance it is all scaled to - in twelve-tone, this should be 12
        compout = []
        compscore = 0
        compcount = 0
        if comp1.length != comp2.length
            abort("ERROR: Comparison arrays are not the same length!: #{comp1.length} vs #{comp2.length}")
        else
            for com in 0...comp1.length
                if comp2[com] != "x"
                    compval = 1-((comp1[com].to_f - comp2[com].to_f).abs/(scaling.to_f))
                    compout.push(compval)
                    compscore += compval
                    compcount += 1
                else
                    compout.push("x")
                end
            end
        end
        if compscore == 0 
            compoutput = 0
        else
            compoutput = (compscore.to_f/compcount)
        end
        return compoutput
    end

def symchooser(in1,in2,symtype)
    #SYMMETRY
    if symtype == "prime"
        if in1 == in2; return 1; else; return 0; end
    elsif symtype == "retrograde"
        if in1 == in2.reverse; return 1; else; return 0; end
    elsif symtype == "inverted"
        in2rev = in2.map{|x| x*-1}; if in1 == in2rev; return 1; else; return 0; end
    elsif symtype == "retogradeinverted"
        in2revinv = in2.map{|x| x*-1}
        in2revinv.reverse!
        if in1 == in2revinv; return 1; else; return 0; end
    elsif  symtype == "pcset"
        if in1 == in2; return 1; else; return 0; end
    elsif symtype == "totalsym"
        in2rev = in2.map{|x| x*-1}
        in2revinv = in2.map{|x| x*-1}
        in2revinv.reverse!
        if (in1 == in2 && @totalsymtype["prime"] == true) || 
            (in1 == in2.reverse  && @totalsymtype["retrograde"] == true) || 
            (in1 == in2rev && @totalsymtype["inverted"] == true) || 
            (in1 == in2revinv  && @totalsymtype["retroinverted"] == true)
            return 1; else; return 0 
        end
    end
end

def windower (inarray,window)
    #SYMMETRY
    #splits array into a series of windows
    # inarray = arrray
    # window = size of window
    windows = []
    for win in 0..(inarray.length-window)
        windows.push(inarray.slice(win,window))
    end
    return windows
end

def windowcompare(wins,symtyper)
    #SYMMETRY
    #this gives a value between 0 and 1 
    # depending upon the level of similarities between a set of arrays
    # e.g. [[0,1,1],[0,1,1],[0,0,1]] would give 0.666 
    # - meaning 2/3rds of the windows are the same.
    nums = (0..(wins.length-1)).to_a
    numcomb = nums.combination(2).to_a
    winlist = []
    for nim in 0...numcomb.length
        numcheck = numcomb[nim]
        if symchooser(wins[numcheck[0]],wins[numcheck[1]],symtyper) == 1
            winlist.push(numcheck) 
        end
    end
    winout = winlist.flatten.uniq
    wincount = [winout.length,wins.length]
    return wincount
end

def symmetry (winin,winarray,symtype)
    # takes in array (winin) and a an array of window sizes (winarray)
    # outputs the total value of symmetry 
    # prime, retrograde, inverted, retrogradeinverted
    winreduce = []
    winarray.each{|x| winreduce.push(x-1) } #this is because a 3 note motif is actually made from 2 vectors, not 3 
    #puts "winreduce #{winreduce}"
    totsym = []
    for blib in 0...winreduce.length
        wid = windower(winin,winreduce[blib])
        if symtype == "pcset"
            wid2 =[]
            wid.each{|x| wid2.push(pcset(x))}
        else
            wid2 = wid
        end
        #puts "wid2 #{wid2}"
        totsym.push(windowcompare(wid2,symtype))
    end
    #puts "totsym #{totsym}"
    totalcombs = 0
    totalmatches = 0
    totsympercentage = []
    totsym.each do |x| 
        totalmatches += x[0] 
        totalcombs += x[1]
        totsympercentage.push(x[0].to_f/x[1])
    end
    return totsympercentage
end

    def pcset (arin2)
        #generates a pcset
        checkrow = []
        for yyy in 0...arin2.length
            inrow = arin2.rotate(yyy)
            rowshift = inrow.map{|zzz| (zzz- inrow[0]) % 12}.sort
            rowshift.unshift(rowshift.max)
            checkrow.push(rowshift)
        end
        checkrow.sort!
        #puts "#{checkrow[0].drop(1)}"
        return checkrow[0].drop(1)
    end

#The following three bits of code allow the calculation of the pearson correlation coefficient.
  def mean (meanin)
    return meanin.inject(0){|sum,x| sum + x } / meanin.length.to_f
  end

  def sd (ary)
    mean = mean(ary)
    summed = ary.inject(0){|sum,x| sum + (x-mean)**2 }
    return Math.sqrt(summed / (ary.length-1).to_f)
  end

  def pearson (xin,yin)
    xysd = sd(xin) * sd(yin)
    xmean = mean(xin)
    ymean = mean(yin)
    sum = 0
    for uu in 0...xin.length
      sum += ((xin[uu] - xmean) * (yin[uu] - ymean)) / xysd.to_f
    end 
    outty =  [(sum / (xin.length -  1).to_f) + 1] # I add 1 to allow its use with arrdistance
    #puts "#{outty}"
    return outty
  end


def topranked (poolin,topno)
  #chooses topno number of top-ranked options
  # then outputs them as an array
  # uses some randomness to assure a larger statistical spread of high-ranking options
  toplist = []
  poolin.each {|zzz| toplist.push(zzz[0])}  
  toplist.uniq!
  toplist.sort!{ |x,y| y <=> x }
  thelist = poolin.sort{ |x,y| y <=> x }

  listhash = Hash[toplist.zip([[]] * toplist.length)]

 # puts listhash

  thelist.each do |aaa| 
    listhash[aaa[0]] = listhash[aaa[0]] + [aaa]
  end
 #   puts listhash

    bigtop = []
    bigamount = topno
    listhash.each do |sss|
      if bigamount > 0
 #       puts "sss: #{sss}"
        slicer = sss[1].shuffle.slice(0..(bigamount/2))
        bigtop.push(slicer)
        bigamount = bigamount - slicer.length
      end
    end
    return bigtop.flatten(1)
end


def topranked2 (array,generations)
    #takes in array and splits it into separate arrays according to value of the first index
    toplist = []
    array.each{|x| toplist.push(x[0])}
    toplist.uniq!
    toplist.sort!{ |x,y| y <=> x }
    count = 0 
    newarr = []
    while (count < toplist.length) && (newarr.length < generations)
        halfnewarr = []
        array.each do |x|
            if x[0] == toplist[count]
                halfnewarr.push(x)
            end
        end 
        halfnewarr.shuffle!
        halfnewarr.each {|x| newarr.push(x)}
        count += 1
    end
    return newarr[0...generations]
end

def checksplit (checkin)
    checkindex = []
    checkvalue = []
    checkin.each do |k,v|
        if v != ""
            checkindex.push(k.to_i)
            checkvalue.push(v)
        end
    end
    return [checkindex, checkvalue]
end

def rowrating (xalg)
    #this rates the row according to the options selected
    #output is: [TOTAL-RATING, [ARRAY-OF-INDIVIDUAL-RATINGS], ORIGINAL ROW]
    #xalg = input row
    ratingarray = []
    vectoredxalg = vectorizer(xalg)
    if @onoff["interval"] == true && @weighting["interval"] != 0
        intarray = []
        intarray.push(@intervalcheck["value"])
        interval = intervalcomp(vectoredxalg,@intervalcheck["type"])
        intarray2 = []
        intarray2.push(interval)
        ratingarray.push(arrdistance(intarray2,intarray,1) * @weighting["interval"])
    end
    if @onoff["prime"] == true && @weighting["prime"] != 0
        primesplit = checksplit(@primecheck)
        prime = symmetry(vectoredxalg,primesplit[0],"prime") 
        ratingarray.push(arrdistance(prime,primesplit[1],1) * @weighting["prime"])
    end
    if @onoff["retrograde"] == true && @weighting["retrograde"] != 0
        retrosplit = checksplit(@retrogradecheck)
        retrograde = symmetry(vectoredxalg,retrosplit[0],"retrograde")
        ratingarray.push(arrdistance(retrograde,retrosplit[1],1) * @weighting["retrograde"])
    end
    if @onoff["inverted"] == true && @weighting["inverted"] != 0
        invertedsplit = checksplit(@invertedcheck)
        inverted = symmetry(vectoredxalg,invertedsplit[0],"inverted")
        ratingarray.push(arrdistance(inverted,invertedsplit[1],1) * @weighting["inverted"])
    end
    if @onoff["retroinverted"] == true && @weighting["retroinverted"] != 0
        retroinvertedsplit = checksplit(@retroinvertedcheck)
        retroinverted = symmetry(vectoredxalg,retroinvertedsplit[0],"retogradeinverted")
        ratingarray.push(arrdistance(retroinverted,retroinvertedsplit[1],1) * @weighting["retroinverted"])
    end
    if @onoff["totalsym"] == true && @weighting["totalsym"] != 0
        totalsymsplit = checksplit(@totalsymcheck)
        totalsym = symmetry(vectoredxalg,totalsymsplit[0],"totalsym")
        ratingarray.push(arrdistance(totalsym,totalsymsplit[1],1) * @weighting["totalsym"])
    end
    if @onoff["pcset"] == true && @weighting["pcset"] != 0
        pcsetsplit = checksplit(@pcsetcheck)
        pcset = symmetry(xalg,pcsetsplit[0],"pcset")
        ratingarray.push(arrdistance(pcset,pcsetsplit[1],1) * @weighting["pcset"])
    end
    if @onoff["pearson"] == true && @weighting["pearson"] != 0
        pearson = pearson((0..11).to_a,xalg)        
        ratingarray.push(arrdistance(pearson,@pearsoncheck,1) * @weighting["pearson"])
    end
    rating = ratingarray.inject(0){|ubu,x| ubu + x }
    miniout = xalg
    miniout.unshift(ratingarray)
    miniout.unshift(rating)
    return miniout
end


def rarerating (xalg)
    #this rates the row according to the options selected
    #output is: [TOTAL-RATING, [ARRAY-OF-INDIVIDUAL-RATINGS], ORIGINAL ROW]
    #xalg = input row
    ratingarray = []
    vectoredxalg = vectorizer(xalg)
    if @onoff["interval"] == true && @weighting["interval"] != 0
        interval = intervalcomp(vectoredxalg,@intervalcheck["type"])
        intarray2 = []
        intarray2.push(interval)
        intarray2.each{|ff| ratingarray.push(ff)}
    end
    if @onoff["prime"] == true && @weighting["prime"] != 0
        primesplit = checksplit(@primecheck)
        prime = symmetry(vectoredxalg,primesplit[0],"prime") 
        prime.each{|ff| ratingarray.push(ff)}
    end
    if @onoff["retrograde"] == true && @weighting["retrograde"] != 0
        retrosplit = checksplit(@retrogradecheck)
        retrograde = symmetry(vectoredxalg,retrosplit[0],"retrograde")
        retrograde.each{|ff| ratingarray.push(ff)}
    end
    if @onoff["inverted"] == true && @weighting["inverted"] != 0
        invertedsplit = checksplit(@invertedcheck)
        inverted = symmetry(vectoredxalg,invertedsplit[0],"inverted")
        inverted.each{|ff| ratingarray.push(ff)}
    end
    if @onoff["retroinverted"] == true && @weighting["retroinverted"] != 0
        retroinvertedsplit = checksplit(@retroinvertedcheck)
        retroinverted = symmetry(vectoredxalg,retroinvertedsplit[0],"retogradeinverted")
        retroinverted.each{|ff| ratingarray.push(ff)}
    end
    if @onoff["totalsym"] == true && @weighting["totalsym"] != 0
        totalsymsplit = checksplit(@totalsymcheck)
        totalsym = symmetry(vectoredxalg,totalsymsplit[0],"totalsym")
        totalsym.each{|ff| ratingarray.push(ff)}
    end
    if @onoff["pcset"] == true && @weighting["pcset"] != 0
        pcsetsplit = checksplit(@pcsetcheck)
        pcset = symmetry(xalg,pcsetsplit[0],"pcset")
        pcset.each{|ff| ratingarray.push(ff)}
    end
    if @onoff["pearson"] == true && @weighting["pearson"] != 0
        pearson = pearson((0..11).to_a,xalg)        
        pearson.each{|ff| ratingarray.push(ff)}
    end
    #puts "Rating Array: #{ratingarray}"
    return ratingarray
end

def average(num)
    #Creates an average of random rows.
    #input is the number of rows to average
    averagerarearray = []
    num.times do 
        testrow = [0,1,2,3,4,5,6,7,8,9,10,11].shuffle
        rowoutput = rarerating(testrow)
        averagerarearray.push(rowoutput)
    end
    #puts "AVERAGE ARRAY: #{averagerarearray}"
    avlength = averagerarearray.length
    avarr = []
    for i in 0...averagerarearray[0].length
        countstore = 0
        averagerarearray.each do |ll|
            countstore += ll[i]
        end
        avarr.push((countstore/avlength))
    end
    #puts "Average: #{avarr}"
    return avarr
end


def rarity (rowin,average)
    #This calculates the rarity of a particular row.
    #First argument is the row, second is the amount of random rows to choose to create an average.
    newrow = rarerating(rowin)
    outter = 1-(arrdistance(newrow,average,1))
    #puts "NEW ROW: #{newrow} / MAINAVERAGE: #{average} / OUTER: #{outter}"
    rowout = rowin
    rowout.unshift(newrow)
    rowout.unshift(outter)
    #puts "WHOLE THING: #{rowout}"
    return rowout
end

def errorchecker ()
    #checks input for errors and creates an array.
  #if the value in the array is 0, it has passed the test, if it is 1, it has failed.
    allboxes = 0 # checks all criteria have at least one box filled in
    weightingfilled = 0  # checks every criteria has a weighting box filled.
    weightingzero = 0 # checks weighting boxes are not less than 0
    valzeroone = 0 #checks no values are < 0 or > 1
    allcrit = 1 # checks at least one criteria is selected

    if @pearsoncheck.length > 0
        pearsy = (@pearsoncheck[0]*0.5).abs #PROBLEM?
    else
        pearsy = 0
    end

    allvalues = { "interval" => {"1" => @intervalcheck["value"]}, 
              "prime" => @primecheck, 
              "retrograde" => @retrogradecheck,
              "inverted" => @invertedcheck,
              "retroinverted" => @retroinvertedcheck,
              "totalsym" => @totalsymcheck,
              "pcset" => @pcsetcheck,
              "pearson" => {"pearson" => pearsy}
    }

    @onoff.each do |k,v|
        if v == true
            if allvalues[k].length == 0 # checks all criteria have at least one box filled in
                allboxes = 1   
            end
            if @weighting[k] == nil # checks every criteria has a weighting box filled.
                weightingfilled = 1
            elsif @weighting[k] < 0 # checks weighting boxes are not less than 0
                weightingzero = 1               
            end
            allvalues[k].each do |ak,av| #checks no values are < 0 or > 1
                if av < 0 || av > 1
                    valzeroone = 1
                end
            end
            allcrit = 0 # checks at least one criteria is selected
        end
    end
    return [allboxes, weightingfilled, weightingzero, valzeroone, allcrit]
end

def geneticprocess (poolsize,generations,type,avamount)
    # This is the main genetic algorithm.  
    # The arguments are: 
    # poolsize = the size of the pool 
    # i.e. the starting set of rows in each generation (the number that survive each generation)
    # generations = the number of generations the code runs for.
    # type = whether the algorithm searches for matches "matches" or rarity "rarity"
    # avamount = if in "rarity" mode, the amount of rows sampled to create an average of the combinatorial space.
    
    #The following makes sure all of the boxes that should be filled are filled:
    errorscheck = errorchecker()

   # allboxes = 0 # checks all criteria have at least one box filled in
   # weightingfilled = 0  # checks every criteria has a weighting box filled.
  #  weightingzero = 0 # checks weighting boxes are not less than 0
  #  valzeroone = 0 #checks no values are < 0 or > 1
   # allcrit = 1 # checks at least one criteria is selected

    puts "#{errorscheck}"

    if errorscheck.inject(0){|sum,z| sum + z} != 0      
        if errorscheck[0] == 1
            @textArea.appendText("ERROR: There are no values specified for one of your types of criteria!\n")
        end
        if errorscheck[1] == 1
            @textArea.appendText("ERROR: One or more of the criteria have no weighting value!\n")
        end   
        if errorscheck[2] == 1
            @textArea.appendText("ERROR: One or more of the weighting values is <0!\n")
        end    
        if errorscheck[3] == 1
            @textArea.appendText("ERROR: One or more of your values are >1 or <0!\n")
        end  
        if errorscheck[4] == 1
            @textArea.appendText("ERROR: No criteria selected!\n")
        end
        solution = 1
    else
        #puts "#{@primecheck}"

        ga = Iterators.new

        @totalweight = 0
        @weighting.each do |k,v|
            if @onoff[k] == true
                @totalweight += v
            end
        end

        if type == "rarity"
            @mainaverage = average(avamount)
        end

        pool = [[0,1,2,3,4,5,6,7,8,9,10,11].shuffle!]
        (poolsize-1).times{pool.push([0,1,2,3,4,5,6,7,8,9,10,11].shuffle!)}
        @smallpool = []
        @textArea.appendText("Evolution Started!...\n")
        puts "STARTING PERMUTATIONS: #{pool}"
        solution = 0
    end

    allsolutions = []
    solutionfound = 0
    counter = 1
    while counter <= generations && solution == 0
        @smallpool = [] # new
        pool.each do |row|
            minipool = []
            iterators = ga.swap_iterator(row) + ga.injecter_iterator(row) + ga.rotator_iterator(row) + ga.transposer_iterator(row) + ga.flipper_iterator(row)
            iterators.push(row)
            iterators.each do |xalg|            
                if type == "matches"
                    ratingofrow = rowrating(xalg) # this rates the rows
                elsif type == "rarity"
                    ratingofrow = rarity(xalg,@mainaverage) # this finds rarity
                end
                minipool.push(ratingofrow)
            end
            minipool.each do |k| 
                @smallpool.push(k)
            end
        end
        @smallpool.keep_if {|bbb| bbb.length >= 13}
        @smallpool.uniq!
        @smallpool.sort!{ |x,y| x <=> y }
        smallpool2 = topranked2(@smallpool,poolsize)

        puts "Generation #{counter}"
        #@smallpool.slice!(0..-(poolsize+1))
        pool = []
        smallpool2.each do |aaa| 
            cleaned = aaa #this rounds excessive floats in the command prompt output
            cleaned.map! do |dd|
                if (dd.is_a? Float) == true
                    dd.round(3)
                elsif (dd.is_a? Array) == true
                    dd.map!{|ee| ee.round(3)}
                else
                    dd
                end
            end
            if aaa[0] == @totalweight #@weighting.values.reduce(:+)
                allsolutions.push("SOLUTION. score: #{cleaned[0]} row: #{cleaned.last(12)} \n")
                solutionfound = 1
                puts "SOLUTION: #{cleaned}"               
            else
                puts "fittest: #{cleaned}"
                if counter == generations && solutionfound == 0
                    @textArea.appendText("fittest. score: #{cleaned[0]} row: #{cleaned.last(12)} \n")
                end
            end
            aaa.delete_at(0)
            aaa.delete_at(0)
            pool.push(aaa)
        end
        2.times{pool.push([0,1,2,3,4,5,6,7,8,9,10,11].shuffle!)}

        counter += 1
    end
    if solutionfound == 1
        allsolutions.uniq!
        allsolutions.each do |x|
             @textArea.appendText("#{x}")
         end
     end
    @textArea.appendText("... Evolution Finished!\n")
    puts "FINISHED!"
end


    def guitoarray (guiarray,algarray)
        #converts gui text boxes into an array that can be used by the algorithm
        guiarray.each do |k,v| 
            if v.text != ""
                tofloat = v.text.to_f
                algarray.store(k,tofloat) 
            end
        end
    end

  def accumulator(matchrare)
    @weighting = Hash.new
    @intervalcheck = Hash.new
    @primecheck = Hash.new
    @retrogradecheck = Hash.new
    @invertedcheck = Hash.new
    @retroinvertedcheck = Hash.new
    @totalsymcheck = Hash.new
    @pcsetcheck = Hash.new
    @pearsoncheck2 = Hash.new # 1=upward slope, -1=downward slope, 0=no relation
    

    if @choice == 0
      @intervalcheck.store("type","harmonic")
    elsif @choice == 1
      @intervalcheck.store("type","melodic")
    end
    @intervalcheck.store("value",@intervalcheck1["value"].text.to_f)

    guitoarray(@primecheck1,@primecheck)
    guitoarray(@retrogradecheck1,@retrogradecheck)
    guitoarray(@invertedcheck1,@invertedcheck)
    guitoarray(@retroinvertedcheck1,@retroinvertedcheck)
    guitoarray(@totalsymcheck1,@totalsymcheck)
    guitoarray(@pcsetcheck1,@pcsetcheck)
    guitoarray(@weighting1,@weighting)
    guitoarray(@pearsoncheck1,@pearsoncheck2)   
    @pearsoncheck = []
    @pearsoncheck2.each_value{|q| @pearsoncheck.push(q + 1)}
    #puts "@pearsoncheck #{@pearsoncheck}"
    #puts "@pearsoncheck2 #{@pearsoncheck2}"

    guitoarray(@weighting1,@weighting)

    pls = @poolsize1.value.to_i #.text.to_i
    gens = @generations1.value.to_i #.text.to_i
    avam = @avamount1.value.to_i #.text.to_i

    geneticprocess(pls,gens,matchrare,avam) 
    # arguments: poolsize,generations,matches/rarity,number of rows sampled to create an average of the space.
  end


  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

if __FILE__ == $0
  FXApp.new do |app|
    TwelveTone.new(app)
    app.create
    app.run
  end
end




