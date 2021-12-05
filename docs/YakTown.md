# YakTown
 a.k.a. [[Stream-Cluster]]
#distributed #stream #delivery #network #infrastructure

## A Day in YakTown
Featuring:
- Alice - First of Yak
- Bob - The Brovisioner
- Carl - The Collaborator

```plantuml-ascii
actor Alice
collections YakOS
actor Bob
actor Carl

Alice -> YakOS : join
YakOS -> Bob : hello I am Alice
Bob -> YakOS : hello Alice
Bob -> Carl : hey Carl guess whois
Carl -> YakOS : whois who?
YakOS -> Carl : [ Alice, Bob, Carl ]
Carl -> Bob : whois Alice?
Bob -> YakOS : whois Alice?
Alice -> YakOS : whoami?
```
