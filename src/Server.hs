module Main where

import Control.Monad (unless)
import Network.Socket
import Control.Exception

port = "3000"

main = withSocketsDo $ bracket connectMe sClose handler
          where
            connectMe = do
              (serveraddr:_) <- getAddrInfo
                                  (Just (defaultHints {addrFlags = [AI_PASSIVE]}))
                                  Nothing (Just port)
              sock <- socket (addrFamily serveraddr) Datagram defaultProtocol
              bindSocket sock (addrAddress serveraddr) >> return sock

handler :: Socket -> IO ()
handler conn = do
    (msg,n,d) <- recvFrom conn 1024
    putStrLn $ "< " ++ msg
    unless (null msg) $ sendTo conn msg d >> handler conn