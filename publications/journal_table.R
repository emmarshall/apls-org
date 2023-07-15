library(gt)
library(tidyverse)

data <- tibble (
  Name = c("Aggression and Violent Behavior", "Behavioral Sciences and the Law", 
           "Behavioral Sciences of Terrorism and Political Aggression", "Child Abuse and Neglect", 
           "Criminal Justice and Behavior", "Criminology", "Criminology and Public Policy", 
           "International Journal of Law and Psychiatry", "International Journal of Forensic Mental Health", 
           "International Journal of Police Science and Management", "Journal of the American Academy of Psychiatry and Law", 
           "Journal of Credibility Assessment and Witness Psychology", "Journal of Criminal Psychology", 
           "Journal of Empirical Legal Studies", "Journal of Forensic Psychiatry and Psychology", 
           "Journal of Forensic Psychology and Practice", "Journal of Forensic Sciences", "Journal of Legal Studies", 
           "Law and Psychology Review", "Legal and Criminological Psychology", "Open Access Journal of Forensic Psychology", 
           "Psychiatry, Psychology and Law", "Psychological Injury and Law", "Psychology, Crime and Law", 
           "Psychology Public Policy and Law"),
  link = c("https://www.journals.elsevier.com/aggression-and-violent-behavior",
         "https://onlinelibrary.wiley.com/journal/10990942",
         "https://www.tandfonline.com/toc/rirt20/current",
         "https://www.journals.elsevier.com/child-abuse-and-neglect",
         "https://journals.sagepub.com/home/cjb",
         "https://onlinelibrary.wiley.com/journal/1745918x",
         "https://onlinelibrary.wiley.com/journal/17459176",
         "https://www.journals.elsevier.com/international-journal-of-law-and-psychiatry",
         "https://www.tandfonline.com/toc/rfmh20/current",
         "https://journals.sagepub.com/home/psm",
         "https://www.jaapl.org/",
         "http://journals.sagepub.com/home/caw",
         "https://www.emerald.com/insight/publication/issn/2009-3829",
         "https://onlinelibrary.wiley.com/journal/17402743",
         "https://www.tandfonline.com/toc/rfpp20/current",
         "https://www.tandfonline.com/toc/hfpp20/current",
         "https://onlinelibrary.wiley.com/journal/15564029",
         "https://www.journals.uchicago.edu/toc/jls/current",
         "https://ir.lawnet.fordham.edu/lpr/",
         "https://bpspsychub.onlinelibrary.wiley.com/journal/20447106",
         "https://www.researchgate.net/journal/2473-2850_Open_Access_Journal_of_Forensic_Psychology",
         "https://www.tandfonline.com/toc/tppl20/current",
         "https://www.springer.com/journal/12207",
         "https://www.tandfonline.com/toc/gpcl20/current",
         "https://www.apa.org/pubs/journals/law/")
)

journal_table <- data |> 
  mutate(link = sprintf('<p>Link to <a href = "%s">%s</a> website', link, Name), 
         link = map(link, gt::html)) |> 
  gt() 

journal_table
