# 1. load library

library(ggdag)
library(tidyverse)
library(dagitty)

# 2. Define the DAGs
# 2.1 Theory DAG
trounstine_dag <- dagify(
  
  # define the path
  B ~ A,
  C ~ B,
  D ~ C,

  
  # Position the nodes
  coords = list(
    
    x = c(
      A = 0,
      B = 1,
      C = 2,
      D = 3
      
    ),
    
    y = c(
      A = 0,
      B = 0,
      C = 0,
      D = 0
    )
  )
)
# map the nodes and arrows
theory_dag <- ggdag(trounstine_dag) +
  theme_dag() +
  labs(
    title = "Trounstine's Theory of Land Use and Segregation"
  )

# save the graph
ggsave("theory_dag.png", theory_dag)

# 2.2 Empirical DAG
trounstine_dag <- dagify(
  
  # Define the main causal path
  G ~ F,
  
  # Define the confounders
 F ~ A,
   F ~ B,
  F ~ C,
 F ~ D,
 F ~ E,
  
  
  # Position the nodes
  coords = list(
    
    x = c(
      A = 0,
      B = 0,
      C = 0,
      D = 0,
      E = 0,
      F = 5,
      G = 6
      
    ),
    
    y = c(
      A = 2,
      B = 1,
      C = 0,
      D = -1,
      E = -2,
      F = 1,
      G = 2
    )
  )
)
# map the nodes and arrows
model_dag <- ggdag(trounstine_dag) +
  theme_dag() +
  labs(
    title = "Trounstine's Model of Land Use and Segregation"
  )

# save the graph
ggsave("model_dag.png", model_dag)
