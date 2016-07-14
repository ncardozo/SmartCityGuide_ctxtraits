(in-package #:cl-user)
(defpackage #:scg (:use #:amos-cl))
(in-package #:scg)

(defproto @guidedVisitViewController ())
(add-slot @guidedVisitViewController itineraryList ())
(add-slot @guidedVisitViewController currentItinerary nil)
(add-slot @guidedVisitViewController mapView nil)
(add-slot @guidedVisitViewController currentPoi 0)

(defmethod next-poi ((gvvc @guidedVisitViewController) (currentPoi)) 
	(defvar *itiPois* (get-itinerary-pois currentItinerary))
	(cond ((eq currentPoi (list-length *itiPois*)) (cancel-itinerary gvvc))
		((t) (setf currentPoi (1+ currentPoi))
			(setf activeItineraryPoiNb (1+ activeItineraryPoiNb))
			(refresh-annotations gvvc))))
			
(defmethod set-itinerary ((gvvc @guidedVisitViewController))
	(format t "~d" (description currentPoi))
	(remove-annotations mapView)
	(add-poi-annotations gvvc)
	(format t "~d/~d" (1+ currentItinerary) (list-length itineraryList)))
	
(defmethod cancel-itinerary ((gvvc @guidedVisitViewController))
	(set-itinerary gvvc)
	(format t "choose itinerary"))
	
(defmethod add-poi-annotations ((gvvc @guidedVisitViewController))	
	(defvar *poiList* (get-itinerary-pois currentItinerary))
	(setf annotations ())
	(loop for x in *poiList*
			i from 0 until (list-length *poiList*)
		do ((defvar *annotationPoi* (make-instance @annotation :poi x :index i))
			(add-annotations mapView *annotationpoi*)
			(cons *annodationPoi* annotations))))
			
(defmethod map-view ((gvvc @guidedVisitViewController) (annotation @annotation))
	(cond ((suptypep annotation 'MKUserLocation) (nil))
		((t) (defvar *pinView* (deque-reusable-annotation mapView "AnnotationIentifier"))
			(cond ((nilp *pinView*) (setf *pinView* (make-instance @annotation :annotation annotation :id "AnnotationIdentifier"))))
			(image *pinView* "number~d" (1+ (index annotation)))
			*pinView*)))

(with-context (@guidedTour)	
	(defmethod chech-nearest-poi ((gvvc @guidedVisitViewController))
		(defvar *location* (location (userLocation mapView)))
		(defvar *nearestPoi* nil)
		(defvar *nearestDistance* 0)
		(defvar *itineraryPois* (get-itinerary-pois currentItinerary))
		(loop for x in *itineraryPois*
			do ((cond ((*nearestPoi*) (setf *nearestpoi* x)
									(setf *nearestDistance* (distance-between x posX posY)))
					((t) (defvar *distance* (distance-between x posX posY))
						(cond ((< *distance* nearestDistance) (setf nearestPoi x)
															(setf *nearestDistance* *distance*))))))))
															
	(defmethod map-view ((gvvc @guidedVisitViewController) (annotation @annotation))
		(cond ((suptypep annotation 'MKUserLocation) (nil))
			((t) (defvar *pinView* (deque-reusable-annotation mapView "AnnotationIentifier"))
				(if (nilp *pinView* (setf *pinView* (make-instance @annotation :id"AnnotationIdentifier")))
				(defvar *index* (1+ (index-itinerary annotation)))
				(defvar *image* "")
				(setf (show-calloutp *pinView*) t)
				(if (eq currentPoi *index*) (setf *image* "number~d" *index*) (setf *image* "number~d_grey" *index*))
				(setf (image *poiView*) *image*)
				*poiView*))))
)
