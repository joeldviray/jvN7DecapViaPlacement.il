/* jvN7DecapViaPlacement.il
 *
 *
 * Author       Joel Viray
 * Language     SKILL
 * Date         July 7, 2019
 *
 * After Decap power placement, this scripts helps remove unwated VIA9.  
 * Condition: No M9 and M10 overlaps
 *  
 */


procedure(abGetOverlapShape(overlap)
  if(listp(overlap) then
      abGetOverlapShape(cadr(overlap))
  else
      overlap
  );if
);procedure

cv=geGetEditCellView()

procedure(jvN7DecapViaPlacement_remove()


    foreach(decap_via geGetSelSet()

        decapViaBbox=decap_via~>bBox

        x1bbox=xCoord(lowerLeft(decapViaBbox))
		y1bbox=yCoord(lowerLeft(decapViaBbox))
        x2bbox=xCoord(upperRight(decapViaBbox))
		y2bbox=yCoord(upperRight(decapViaBbox))

        reduced_decapViaBbox=list(x1bbox+0.1:y1bbox+0.1 x2bbox-0.1:y2bbox-0.1)

        
        M9_overlaps=dbProduceOverlap(cv reduced_decapViaBbox 32 list("M9" "drawing"))
        M10_overlaps=dbProduceOverlap(cv reduced_decapViaBbox 32 list("M10" "drawing"))
       


        flattened_M9_overlaps=foreach(mapcar overlap M9_overlaps
                              srcShape=abGetOverlapShape(overlap)
                              ;dbCopyFig(srcShape cv dbGetHierPathTransform(overlap))
                              );foreach

        flattened_M10_overlaps=foreach(mapcar overlap M10_overlaps
                              srcShape=abGetOverlapShape(overlap)
                              ;dbCopyFig(srcShape cv dbGetHierPathTransform(overlap))
                              );foreach

       


        if(length(flattened_M9_overlaps)<2||length(flattened_M10_overlaps)<2
            then
            dbDeleteObject(decap_via)
        );if
      
               
    );foreach

);procedure
