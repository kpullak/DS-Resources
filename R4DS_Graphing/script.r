# R for Data Science: Graphing
# NC State University Libraries
# 2/19/19

# Run these lines first to install and load required packages

install.packages("ggplot2")
install.packages("ggrepel")
library(ggplot2) 
library(ggrepel)

# Note: many examples come from the R for Data Science textbook: 
# https://r4ds.had.co.nz/
  
# Section 1. Scatterplots and faceting
# 1. Learn more about the mpg dataset. Run the following code:

?mpg

# 2. Examine the first few rows of the mpg data set. Run the following code:

head(mpg)

# 3. Create a scatterplot with ggplot2, plotting engine displacement on the X-axis 
# and highway mileage on the Y-axis. Make sure to put the "+" sign at the end of the line, 
# not at beginning of next line

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))
# aes is for aesthetics

# shortcut way of writing it:
ggplot(mpg) + geom_point(aes(displ, hwy)) 

# 4. Practice. Create a scatterplot plotting the cylinder (cyl) as x 
# and highway mileage (hwy) on the y-axis. 
# Type the code below. Run the code to test it!

ggplot(data = mpg) + geom_point(mapping = aes(x = cyl, y = hwy))

# shortcut way of writing it:
ggplot(mpg) + geom_point(aes(cyl, hwy))

# 5. Make a scatterplot of x=displ and y=hwy. Color the dots by class using color=class inside aes(). 
ggplot(mpg) + geom_point(aes(displ, hwy, color=class))

# 6. Practice. Copy the code in #5, but substitute another aesthetic in place of color (size, shape, or alpha).
ggplot(mpg) + geom_point(aes(displ, hwy, color=class, shape=class, alpha=class))

# alpha is for transparency

# 7. Add another layer to the graph. Adding geom_smooth() adds a fit line.
ggplot(mpg) + 
  geom_point(aes(displ, hwy, color=class)) + # this is layer 1
  geom_smooth(aes(displ, hwy))  # this is layer 2

# geom_smooth -> adding a line based on it's own choice, it looks at data and
# decides which algorithm to use to draw that line.
?geom_smooth
# method has so many options, algorithms that we could use.

# Note: To make code more effcient, but the information shared by all layers in the ggplot function: 
ggplot(mpg, aes(displ, hwy)) + # put the information all layers share here
  geom_point(aes(color=class)) + # this is layer 1
  geom_smooth()  # this is layer 2

# we can think of ggplot as a global layer, the inner layers like geom_point, we 
# specifically put stuff in this function, which that function alone can work on.

# 8. Add a text layer to the graph 
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color=class)) + # this is layer 1
  geom_smooth() +  # this is layer 2
  geom_text(label=ifelse(mpg$hwy>40, mpg$manufacturer, ""))

# 'geom_text' is a layer which we can use to add labels to the graphs.
# We have added a conditional statement (ifelse) to check what data points to label.

# incase we are having overlapping labels (labels & data points) we can add a parameter called 'hjust' to offset the labels from the datapoints
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color=class)) + # this is layer 1
  geom_smooth() +  # this is layer 2
  geom_text(label=ifelse(mpg$hwy>40, mpg$manufacturer, ""), hjust = .25)


# 8. To prevent labels from overlapping, use geom_label_repel instead of geom_text:
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color=class)) + # this is layer 1
  geom_smooth() +  # this is layer 2
  geom_label_repel(label=ifelse(mpg$hwy>40, mpg$manufacturer, ""))

# incase we are having overlapping labels (labels & data points) we can add a parameter called 'hjust' to offset the labels from the datapoints
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color=class)) + # this is layer 1
  geom_smooth() +  # this is layer 2
  geom_label_repel(label=ifelse(mpg$hwy>40, mpg$manufacturer, ""), hjust = 0.25)

# Creating subplots
# 9. Facet_wrap() creates subplots. Run this code to see what faceting does:
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color=class)) + 
  geom_smooth() + 
  facet_wrap(~class)

# breaking up each class with a subplot of it's own

# 10. Practice Faceting. Create a plot of displ, hwy like the one above,
# but put the cyl variable inside of the facet_wrap() function. Use #7 as an example.
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color=cyl)) + 
  geom_smooth() + 
  facet_wrap(~cyl)

# breaking up each cylinder with a subplot of it's own, color=cyl, makes the
# 'color palette' discrete, same as the cylinder numbers

# 11. Facet grids allow for an extra dimension of faceting. Run this code to see what facet_grid() does:
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color=class)) +
  facet_grid(class ~ cyl)

# We can create a facet_grid, using two variables, here we are faceting on class & cylinders

# Changing colors and chart themes
# Source: http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/

# 12. Change the color scale of the dots using built-in scale.
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color=class)) + 
  scale_color_brewer(palette="Dark2")
?scale_color_brewer

# 13. Set colorblind-friendly palette using manual scale.
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color=drv)) + 
  scale_color_manual(values=cbPalette) 
?scale_color_manual
  
# 14. Change chart theme using a theme function.
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color=drv)) + 
  scale_color_manual(values=cbPalette) +
  theme_classic()
?theme_classic

## Section 2. Bar charts and histograms
# We'll be using the diamonds dataset for this section: 
head(diamonds)
?diamonds

# 15. Bar chart example. Run this example in the code to create a bar chart:
ggplot(diamonds) + geom_bar(aes(x=cut))

?geom_col
# It takes as input both x-variable & y-variable

# 16. Flip the bars with coord_flip() 
ggplot(diamonds) + geom_bar(aes(x=cut)) + coord_flip()

# 17. Practice. Create a bar chart for the clarity variable. 
ggplot(diamonds) + geom_bar(aes(clarity))

# 18. Histogram example. Create a histogram of price.
ggplot(diamonds) + geom_histogram(aes(price))

# 19. Change the binwidth on the histogram, add color and theme.
ggplot(diamonds) + 
  geom_histogram(aes(price), binwidth = 500, fill="black", col="white") +
  theme_classic()

#col here represents the outline -> we have chosen to give a 'white' outline for the bars

# 20. Practice. Create a histogram of the depth variable. Experiment with binwidth and theme.
ggplot(diamonds) + geom_histogram(aes(depth))

ggplot(diamonds) + 
  geom_histogram(aes(depth), binwidth = 0.5, fill="black", col="white") +
  theme_classic()

## Section 3. Editing scales

# 21. Change the tick marks on the x-axis from defaults.

ggplot(diamonds) + 
  geom_histogram(aes(price), binwidth = 500, fill="black", col="white") +
  scale_x_continuous(breaks=seq(0,20000,by=3000)) + 
  theme_classic()

# we can use any of the different scale functions available in the library
?scale_x_continuous

## Section 4. Adding labels and saving your graph

# 22. Add labels to inform your audience about the graph 

ggplot(diamonds) + 
  geom_histogram(aes(price), binwidth = 500, fill="black", col="white") +
  scale_x_continuous(breaks=seq(0,20000,by=3000)) + 
  theme_classic() +
  labs(
    title = "Count of Diamonds by Price",
    subtitle = "Prices are in U.S. Dollars (n=53940)", 
    y=""
  )
# usually by default if we plot a graph the labels are created from the variable names
# from the data, we can override it using the 'labs' function as outlined above.

# 23. Save plot using ggsave(). Assign graph to a variable name.
# Reference: http://ggplot2.tidyverse.org/reference/ggsave.html 
# Run this code:

my_graph <- ggplot(diamonds) + 
  geom_histogram(aes(price), binwidth = 500, fill="black", col="white") +
  scale_x_continuous(breaks=seq(0,20000,by=3000)) + 
  theme_classic() +
  labs(
    title = "Count of Diamonds by Price",
    subtitle = "Prices are in U.S. Dollars (n=53940)", 
    y=""
  )

my_graph #print the graph to see it

# 24. Use a basic ggsave function to save graph as a .PNG file

ggsave("graph.png", my_graph) # this will save the image file to your current working directory. If you want to save to a different place, add path information before the file name. Ex: "~/Documents/Project_Folder/graph.png"

# 25. Re-save graph as a different size in order to see it all. Units are in inches

ggsave("graph_resized.png", my_graph, width=5, height=5, units="in")

# 26. Save to publication-quality .tiff file

ggsave("graph.tiff", my_graph, width=5, height=5, units="in", dpi=800)
# dpi - dots per inch