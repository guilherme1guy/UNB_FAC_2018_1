#include <stdio.h>
#include <math.h>


double cubic_power(double d){

    return d * d * d;

}

double calc_error(double d, double root){

    double error = (d - cubic_power(root));

    if(error < 0){
        error *= -1;
    }

    return error;

}

double cubic_root(double d){

    const double step = 0.01f;

    double root;
    double error;

    int iterations = 10;

    double lower_limit, cubic_lower;
    double upper_limit, cubic_upper;

    double root_approx, cubic_root_approx;


    for(double itr = 0; ; itr = itr + step){

        lower_limit = itr;
        cubic_lower = cubic_power(itr);
        
        upper_limit = itr + step;
        cubic_upper = cubic_power(itr + step);

        if (cubic_lower < d && cubic_upper > d){
            break;
        }
    }

  

    for (int i = 0; i < iterations; i++){
        
        root_approx = (lower_limit + upper_limit) / 2;

        cubic_root_approx = cubic_power(root_approx);

        printf("\nLower limit: %lf ;; Upper limit: %lf ;; root_approx: %lf ;; Cubic root_approx: %lf;; Error: %lf", lower_limit, upper_limit, root_approx, cubic_root_approx, calc_error(d, cubic_root_approx));

        if (cubic_root_approx < d){

           lower_limit = root_approx; 
        
        }else if(cubic_root_approx > d){
       
            upper_limit = root_approx;
       
        }


    }

    return root_approx;

}


int main(){

    double d;

    printf("double: ");
    scanf("%lf", &d);

    printf("\n\nTest value: %lf ;; Real cubic root: %lf \n\n", d, cbrt(d));


    double root = cubic_root(d);
    double error = calc_error(d, root);

    printf("\n\nResult: %lf ;; Error: %lf\n", root, error);

}