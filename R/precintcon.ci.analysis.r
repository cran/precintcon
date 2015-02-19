#' @export 
precintcon.ci.analysis <- function(..., interval = 1) {
	
	l <- list(...)
	
	if (length(l) > 0) {
		
		set <- NULL
		
		pars <- as.list(match.call()[1:length(l)+1])
		
		for (i in 1:length(l)) {
			
			data <- NULL
			
			object <- l[[i]]
			
			if (is.element("precintcon.daily", class(object)))
				object <- precintcon.fd(precintcon.classification(object, interval))
			
			if (is.element("precintcon.fd", class(object))) {
				
				a  <- exp(precintcon.ln.a(object$p.sum.n, object$p.sum.P))
				b  <- precintcon.b(object$p.sum.n, object$p.sum.P)
				r2 <- precintcon.r.squared(object, a, b * 100)
				A  <- (a/b) * (exp(1)^(b*100)) * (100 - (1/b))
				S  <- 5000 - A
				ci <- 2 * S / 10000
				
				inverse = function (f, lower = -100, upper = 100) {
					function (y) uniroot((function (x) f(x) - y), lower = lower, upper = upper)[1]
				}
				
				x_ <- inverse((function(x) a * x * exp (b * x)), lower=0, upper=100)
				
				data <- data.frame(a=a, b=b, r2=r2, A=A, S=S, ci=ci, 
						PP_5=x_(05)$root, PP_10=x_(10)$root, PP_15=x_(15)$root, PP_20=x_(20)$root, 
						PP_25=x_(25)$root, PP_30=x_(30)$root, PP_50=x_(50)$root)
				
				class(data) <- c("data.frame", "precintcon.ci")
		
				if (length(l) == 1)
					return(cbind(dataset=paste(pars[[i]], sep=""),data))
				else
					set <- rbind(set, cbind(data.frame(dataset=paste(pars[[i]], sep="")), data))
				
			} else 
				stop("object should be of type \"precintcon.fd\"")
		}
		
		class(set) <- c("data.frame", "precintcon.ci")
				
		return(set)
		
	} else {
		stop("precintcon.ci.analysis function called without input data.");
	}
}
