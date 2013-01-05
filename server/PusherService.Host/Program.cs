

namespace PusherService.Host 
{
	using System;
	using System.Collections.Generic;
	using System.ServiceModel;

	class Program {
		static void Main (string[] args)
		{
			ServiceHost host = new ServiceHost (typeof (PusherService));

			try {
				host.Open ();
				Console.WriteLine ("The service is ready and listening on port: {0}\n", host.Description.Endpoints[0].Address.Uri.Port.ToString ());
				Console.WriteLine ("Press <ENTER> to terminate service");
				Console.ReadLine ();
			} catch (System.TimeoutException ex) {
				Console.WriteLine (ex.Message);
				Console.ReadLine ();
			} catch (CommunicationException ex) {
				Console.WriteLine (ex.Message);
				Console.ReadLine ();
			} finally {
				host.Close ();
			}	
		}
	}
}
