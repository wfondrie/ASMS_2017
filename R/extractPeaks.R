# extractPeaks()

# massPeaks - a MassPeaks object from MALDIquant
# massSpec  - a MassSpectra object from MALDIquant

# Output - A tibble with 4 columns:
#   type   - the species or resistance + species of the spectrum
#   mz     - the m/z
#   relInt - the relative intensity at the specified m/z, relative to the 
#            base peak

extractPeaks <- function(massPeaks, massSpec) {
    feat <- as_tibble(intensityMatrix(massPeaks, massSpec))
    fname <- map_chr(massPeaks, ~ metaData(.)$file)
    num <- map_chr(massPeaks, ~ metaData(.)$num)
    type <- str_match(fname, "([^\\^/]+)[\\/][^\\^/]+mzXML$")[ , 2]
    id <- paste(str_match(fname, "([^\\^/]+).mzXML$")[ , 2], num, sep = "_n")
    species <- str_match(type, "(.+) - ")
    
    feat$id <- as.factor(id)
    feat$type <- as.factor(type)
    
    feat <- feat %>%
        gather(mz, relInt, -id, -type) %>%
        group_by(type, id) %>% 
        mutate(relInt = relInt / max(relInt),
               mz = as.numeric(mz)) %>%
        ungroup()
    
    return(feat)
}

