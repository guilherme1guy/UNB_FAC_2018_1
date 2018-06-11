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

  
    int max_loops = 100;
    while (calc_error(root_approx, d) > 0.000000000001 && max_loops > 0){
        
        root_approx = (lower_limit + upper_limit) / 2;

        cubic_root_approx = cubic_power(root_approx);

        printf("\nLower limit: %f ;; Upper limit: %f ;; root_approx: %f ;; Cubic root_approx: %f;; Error: %f", lower_limit, upper_limit, root_approx, cubic_root_approx, calc_error(d, cubic_root_approx));

        if (cubic_root_approx < d){

           lower_limit = root_approx; 
        
        }else if(cubic_root_approx > d){
       
            upper_limit = root_approx;
       
        }

        max_loops--;
    }

    return root_approx;

}


int main(){

    double d;

    printf("double: ");
    scanf("%lf", &d);

    double root = cubic_root(d);
    double error = calc_error(d, root);

    printf("\n\nResult: %lf ;; Error: %lf", root, error);
    printf("\nValue: %lf ;; Real cubic root (C math.h): %lf \n\n", d, cbrt(d));

}