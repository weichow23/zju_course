#include <iostream>
#include <stdexcept>
using namespace std;
#include "CQueue.h"

int main()
{
	try {
		CQueue<double> rq;
		for (int i = 0; i < rq.getSize()-1; i++)   
			rq.enQueue(i);

		if (rq.isFull()) printf("now the queue is full! ");
		
		if (!rq.isEmpty()) rq.show();

		cout << rq.getHead() << " ";

		for (int i = 0; i < 5; i++)   // dequeueing 5 elements			
			rq.deQueue();
		rq.show();
	}
	catch (overflow_error& r)
	{
		cout << r.what();
	}
	catch (underflow_error& r)
	{
		cout << r.what();
	}
	
	return 0;
}
