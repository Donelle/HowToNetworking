

namespace PusherService.Host 
{
	using System;
	using System.Collections.Generic;
	using System.Net;
	using System.ServiceModel;
	using System.Linq;
	using System.Net.Sockets;

	class Program {
		static void Main (string[] args)
		{
			ServiceHost host = new ServiceHost (typeof (PusherService));

			try {
				host.Open ();
				var port = host.Description.Endpoints[0].Address.Uri.Port;
				var address = Dns.GetHostAddresses (Dns.GetHostName ())
						 .Where (ip => ip.AddressFamily == AddressFamily.InterNetwork)
						 .First ();
				
				Console.WriteLine ("The service is ready and listening on: {0}:{1}\n", address, port);
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
