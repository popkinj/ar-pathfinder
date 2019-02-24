# Accounts Receivable Pathfinder Tool

## Development

### Dependencies
- Node 6.x+
- Git CLI
  
### Running Development Environment
```bash
git clone git@github.com:popkinj/ar-pathfinder.git
cd ar-pathfinder
npm install
npm run dev
```

## Deploying

```bash
npm run build
git push
```

## Testing
### Connecting to a Openshift Pod
Log into a shell
```bash
oc get pods
oc rsh podname
```

...or run a command
```bash
oc get pods
oc exec podname command
```

