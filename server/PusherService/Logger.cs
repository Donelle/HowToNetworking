

namespace PusherService {
	using System;
	using log4net;
	using log4net.Config;

	[Flags]
	public enum PSLogLevel {
		Debug = 2,
		Info = 4,
		Warn = 8,
		Error = 16,
		Fatal = 32
	};

	public static class PSLogger {
		#region Fields
		static readonly ILog logger;
		#endregion

		#region Construction

		static PSLogger ()
		{
			XmlConfigurator.Configure ();
			logger = LogManager.GetLogger (typeof (PSLogger));
		}

		#endregion

		#region Methods

		public static void LogException (Exception ex)
		{
			Log (PSLogLevel.Fatal, ex.DebugException ());
		}

		public static void Log (PSLogLevel level, String message)
		{
			if (level == (PSLogLevel.Debug & level))
				logger.Debug (message);

			if (level == (PSLogLevel.Error & level))
				logger.Error (message);

			if (level == (PSLogLevel.Fatal & level))
				logger.Fatal (message);

			if (level == (PSLogLevel.Info & level))
				logger.Info (message);

			if (level == (PSLogLevel.Warn & level))
				logger.Warn (message);

		}

		#endregion
	}
}
